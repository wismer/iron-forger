
module Gitter
  class Done
    def initialize
      @commands = ARGV
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

    def stash
      puts 'stash'
    end
  end
end

gitter = Gitter::Done.new

# gitter init (initialize directory - creates a hidden folder called .mygintermygitter)
# gitter stash (copies working directory into the hidden one)
