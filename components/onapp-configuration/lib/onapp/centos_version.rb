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

    def centos7?
      version == 7
    end
    alias_method :seven?, :centos7?

    private

    # TODO: refactor & write specs(CORE-7983)
    def cat_version
      /\s(?<version>\d)(\.\d+){1,2}\s/ =~ `cat /etc/redhat-release`
      version.to_i
    end
  end
end
