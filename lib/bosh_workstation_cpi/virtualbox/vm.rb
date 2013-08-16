require "bosh_workstation_cpi/virtualbox/error"

module BoshWorkstationCpi::Virtualbox
  class Vm
    attr_reader :uuid

    def initialize(driver, uuid, logger)
      @driver = driver
      raise ArgumentError, "uuid must not be nil" \
        unless @uuid = uuid
      @logger = logger
    end

    def start
      @logger.debug("virtualbox.vm.#{__method__}")

      mode = ENV["BOSH_WORKSTATION_CPI_GUI"] ? "gui" : "headless"
      output = @driver.execute(
        "startvm", @uuid, 
        "--type",  mode,
        {ignore_non_zero_exit_code: true},
      )

      unless output =~ /VM ".+?" has been successfully started/
        raise BoshWorkstationCpi::Virtualbox::Error, \
          "Failed to start VM '#{@uuid}'"
      end
    end

    def state
      @logger.debug("virtualbox.vm.#{__method__}")
      output = @driver.execute("showvminfo", @uuid, "--machinereadable")
      if output =~ /^name="<inaccessible>"$/
        :inaccessible
      elsif output =~ /^VMState="(.+?)"$/
        $1.to_sym
      end
    end

    def running?
      @logger.debug("virtualbox.vm.#{__method__}")
      state == :running
    end

    def name=(name)
      @logger.debug("virtualbox.vm.#{__method__} name=#{name}")
      @driver.execute("modifyvm", @uuid, "--name", name)
    end

    def halt
      @logger.debug("virtualbox.vm.#{__method__}")
      @driver.execute("controlvm", @uuid, "poweroff")
    end

    def delete
      @logger.debug("virtualbox.vm.#{__method__}")
      @driver.execute("unregistervm", @uuid, "--delete")
    end
  end
end
