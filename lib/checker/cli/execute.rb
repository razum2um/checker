class CoreExt
  def self.constantize(camel_cased_word)
    names = camel_cased_word.split('::')
    names.shift if names.empty? || names.first.empty?

    constant = Object
    names.each do |name|
      constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
    end
    constant
  end
end

class String
  def constantize
    CoreExt.constantize(self)
  end
end

module Checker
  class CLI
    module Execute
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def execute
          ## no args, execute how it is  stored in git config
          if ARGV.size == 0
            modules = Utils.get_modules_to_check

            ## check all the modules
            if modules.include?("all")
              exit (Checker::Modules::All.check ? 0 : 1)
            else
              checked = []
              modules.each do
                klass = "Checker::Modules::#{modules.downcase.capitalize}".constantize
                checked << klass.check
              end
              exit (checked.all_true? ? 0 : 1)
            end
          end

          # if ARGV.size < 2
          #   puts "For now only one thing works..."
          #   puts "checker check haml"
          #   exit 
          # end
          # command = ARGV[0]
          # which   = ARGV[1]

          # if which == "all"
          #   ['haml', 'ruby'].each do |m|
          #     puts "Checking #{m} files..."
          #     system("checker check #{m}")
          #   end
          # else
          #   klass = "Checker::Modules::#{which.capitalize}"
          #   require "checker/modules/#{which.downcase}"
          
          #   exit (klass.constantize.check ? 0 : 1)
          # end
        end
      end
    end
  end
end
