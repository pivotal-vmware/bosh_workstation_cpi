require "fileutils"
require "bosh_workstation_cpi/runners/base"

module BoshWorkstationCpi::Runners
  class Local < Base
    def upload!(src_dir, dst_dir)
      FileUtils.mv(src_dir, dst_dir)
    end

    def put!(dst_path, contents)
      File.open(dst_path, "w") { |f| f.write(contents) }
    end

    def get!(dst_path)
      File.read(dst_path)
    end

    protected

    def execute_raw(cmd)
      output = `#{cmd} 2>&1`
      [$?.exitstatus, output]
    end
  end
end
