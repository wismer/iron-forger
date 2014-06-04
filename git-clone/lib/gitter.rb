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

    def head
      if block_given?
        yield non_directories.map { |x| File.read(x) }.join('')
      else
        puts 'Current Head Version Hash: ' + File.read("./.mygit/head").chomp
      end
    end

    def log
      yaml.each { |key, val| puts "#{val[0]['time']}, #{val[0]['commit']} for #{key}"}
    end

    def latest
      revert_to latest
    end

    def status
      if gitter_initialized?
        show_changes
      else
        puts 'You need to initialize this directory!'
      end
    end

    def init
      if !gitter_initialized?
        FileUtils.mkdir('./.mygit')
        yaml_entry
        create_sub_dir
      else
        puts 'already initialized!'
      end
    end

    def add(file)
      if all_unchanged?
        puts "Everything up-to date."
      else
        create_sub_dir(latest+1)
        yaml_entry(latest+1)
      end
    end

    def latest
      yaml.keys.last
    end

    def revert(ver)
      ver = latest if ver == 'latest'

      if gitter_initialized?
        contents = YAML.load_file("./.mygit/desig.yaml")

        contents[ver.to_i].each do |file|
          FileUtils.cp("./.mygit/#{ver}/#{file['file']}", "./#{file['file']}")
        end
      else
        puts 'Directory not initialized!'
      end
    end

    alias :revert_to :revert

    private

      def all_unchanged?
        yaml[latest].all? { |file| !file_changed?(file) }
      end

      def non_directories
        @contents.select { |f| File.file?(f) }
      end

      def gitter_initialized?
        Dir.exist?('./.mygit')
      end

      def create_sub_dir(sub_dir=1)
        @contents.each do |dir|
          if File.file?(dir)
            FileUtils.mkdir_p "./.mygit/#{sub_dir}/" + File.dirname(dir)
            FileUtils.cp dir, "./.mygit/#{sub_dir}/#{dir}"
          else
            FileUtils.mkdir_p dir
          end
        end
      end

      def show_changes
        yaml[latest].each do |file|
          if file_changed?(file)
            puts "\n --- #{file['file']} waiting to be added."
          else
            puts "\n --- #{file['file']} unchanged."
          end
        end
        @contents = yaml[latest].select { |file| file_changed?(file) }
      end

      def file_changed?(file)
        sha(File.read file['file']) != file['hash']
      end

      def parse_commands
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

      def commit_msg
        @commands.last + "\n"
      end

      def yaml_entry(n=1, mode='a+')
        File.open('./.mygit/desig.yaml', mode) do |file|
          file.write("#{n}:\n")
          @contents.each do |r|
            if File.file?(r)
              hash = sha File.read(r)
              file.write("  - file: #{r}\n")
              file.write("    time: #{Time.now}\n")
              file.write("    hash: #{hash}\n")
              file.write("    commit: #{commit_msg}") if @commands.include?("-m")
            end
          end
        end

        head { |h| File.open('./.mygit/head', 'w') { |file| file.write sha(h) } }
      end

      def sha(str)
        Digest::SHA1.hexdigest(str)
      end

      def yaml
        YAML.load_file("./.mygit/desig.yaml")
      end
  end
end


