#!/usr/bin/env ruby

require 'json'
require 'base64'
require 'pathname'
require 'fileutils'

class CertsExtrator
  attr_accessor :input_path
  attr_accessor :output_path

  def initialize(input_path: nil, output_path: '/tmp')
    self.input_path = Pathname.new(input_path) unless input_path.nil?
    self.output_path = Pathname.new(output_path)

    Dir.chdir(input_path)
  end

  def files
    Dir.glob('*.json')
  end

  def extract_all
    files.each do |file|
      extract(file)
    end
  end

  def extract(file)
    puts "extracting file #{file}"
    CertificateFile.new(file, output_path: output_path).extract
  end

  class CertificateFile
    attr_accessor :file, :output_path
    attr_accessor :json

    def initialize(file, output_path:)
      self.file = file
      self.output_path = output_path

      puts `pwd`
      puts `ls #{file}`
      self.json = JSON.parse(File.read(file))
    rescue JSON::ParserError
      self.json = nil
    end

    def file_reference
      File.basename(file, File.extname(file))
    end

    def certificates
      return [] if json.nil?

      json[file_reference]['Certificates'].map do |c|
        Certificate.new(c)
      end
    end

    def extract
      certificates.each do |c|
        # directory = output_path.join(file_reference).join(c.name)
        directory = output_path.join(c.name)
        FileUtils.mkdir_p(directory)

        {
          private_key: 'privkey.pem',
          cert: 'cert.pem',
          chain: 'chain.pem',
          fullchain: 'fullchain.pem',
        }.each do |code, filename|
          File.open(directory.join(filename), 'w') do |f|
            f.write(c.send(code))
          end
        end
      end
    end
  end

  class Certificate
    attr_accessor :name, :private_key, :fullchain, :sans
    attr_accessor :cert, :chain

    def initialize(hash)
      self.name = hash['domain']['main']
      self.private_key = Base64.decode64(hash['key'])
      self.fullchain = Base64.decode64(hash['certificate'])
      self.sans = hash['domain']['SANs']

      idx = fullchain.index('-----BEGIN CERTIFICATE-----', 1)
      self.cert = fullchain[0...idx].strip + "\n"
      self.chain = fullchain[idx...].strip + "\n"
    end

  end
end

input_path = ARGV[0]
output_path = ARGV[1]

CertsExtrator.new(input_path: input_path, output_path: output_path).extract_all
