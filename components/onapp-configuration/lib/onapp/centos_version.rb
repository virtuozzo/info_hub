module OnApp
  class CentOSVersion
    def version
      @version ||= Utils::RedhatRelease.major_version(release_string)
    end

    def centos5?
      version == 5
    end
    alias_method :five?, :centos5?

    def centos6?
      version == 6
    end
    alias_method :six?, :centos6?

    def centos7?
      version == 7
    end
    alias_method :seven?, :centos7?

    private

    def release_string
      @release_string ||= `cat /etc/redhat-release`
    end
  end
end
