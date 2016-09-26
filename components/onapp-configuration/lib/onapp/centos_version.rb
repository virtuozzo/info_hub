module OnApp
  class CentOSVersion
    def version
      @version ||= cat_version
    end

    def centos5?
      version == 5
    end
    alias_method :five?, :centos5?

    def centos6?
      version == 6
    end
    alias_method :six?, :centos6?

    private

    def cat_version
      /\s(?<version>\d)\.\d+\s/ =~ `cat /etc/redhat-release`
      version.to_i
    end
  end
end
