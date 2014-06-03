require 'fileutils'
require 'yaml'
require 'gitter/recorder'

module Gitter

  class Done
    def initialize
      @commands = ARGV
      @contents = Dir["*/**/**"]
      @yamit    = Recorder.new
      parse_commands
    end

    def parse_commands
      until @commands.empty?
        cmd = @commands.shift
        if respond_to? cmd.downcase
          if self.method(cmd).arity == 1
            flag = @commands.shift
            self.send(cmd, flag)
          else
            self.send(cmd)
          end
        else
          raise 'some error of some kind'
        end
      end
    end

    def yaml_entry(n=1)
      File.open('./.mygit/desig.yaml', 'a+') do |file|
        file.write("#{n}:\n")
        @contents.each do |r|
          if File.file?(r)
            hash = Digest::SHA1.hexdigest File.read(r)
            file.write("  - file: #{r}\n")
            file.write("    time: #{Time.now}\n")
            file.write("    hash: #{hash}\n")
          end
        end
      end
    end

    def status
      @data = YAML.load_file("./.mygit/desig.yaml")

      @data['files'].each do |file|
        puts "The following files have had changes to them:\n"
        if file_changed?(file)
        end
      end
    end

    def init
      if !gitter_initialized?
        FileUtils.mkdir('./.mygit')
        yaml_entry
      #   @recorder.init_files(current)
      #   current.each do |dir|
      #     if File.file?(dir)
      #       FileUtils.mkdir_p "./.myop/1/" + File.dirname(dir)
      #       FileUtils.cp dir, "./.myop/1/#{dir}"
      #     else
      #       FileUtils.mkdir_p dir
      #     end
      #   end
      else
        puts 'already initialized!'
        # raise 'Directory has already been initialized!'
      end
    end

    def add(file)
    end

    def revert(ver)
      contents = YAML.load_file()
      contents[ver].each do |file|
        FileUtils.cp("./.mygit/#{ver}/#{file}", file, :force => true)
      end

      update_yaml
    end

    def update_yaml
    end

    def stash
    end

    def gitter_initialized?
      Dir.exist?('./.myop')
    end
  end
end


