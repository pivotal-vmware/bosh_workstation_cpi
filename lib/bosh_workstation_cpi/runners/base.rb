require "shellwords"

module BoshWorkstationCpi::Runners
  class Base
    class Error < StandardError; end

    def initialize(logger)
      @logger = logger
    end

    def execute_raw(cmd)
      raise NotImplementedError, "#{__method__}"
    end

    def execute(*cmd_pieces)
      execute_raw(Shellwords.shelljoin(cmd_pieces))
    end

    def execute!(*args)
      execute(*args).tap do |(exit_code, output)|
        raise Error, "Command '#{args.inspect}' exited with non-0" \
          unless exit_code.zero?
      end
    end

    def upload!(src_dir, dst_dir)
      raise NotImplementedError, "#{__method__}"
    end

    def put!(dst_path, contents)
      raise NotImplementedError, "#{__method__}"
    end

    def get!(dst_path)
      raise NotImplementedError, "#{__method__}"
    end

    protected

    attr_reader :logger
  end
end
