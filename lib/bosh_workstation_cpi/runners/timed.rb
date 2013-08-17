require "bosh_workstation_cpi/runners/base"

module BoshWorkstationCpi::Runners
  class Timed < Base
    def initialize(runner, *args)
      super(*args)
      @runner = runner
    end

    %w(execute execute! upload! put! get!).each do |method|
      define_method(method) do |*args|
        log_time(method, args) { @runner.send(method, *args) }
      end
    end

    private

    def log_time(method, args, &blk)
      t1 = Time.now
      blk.call
    ensure
      t2 = Time.now

      # Careful logging all args since they
      # might contain iso contents, etc.
      logger.debug(
        "runners.timed.log_time " + 
        "time=#{"%.03f" % (t2 - t1)}s " + 
        "method=#{method} " + 
        "args=#{args.first.inspect}"
      )
    end
  end
end
