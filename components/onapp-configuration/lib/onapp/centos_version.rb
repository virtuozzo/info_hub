module OnApp
  class CentOSVersion
    delegate  :centos5?, :centos6?, :centos7?, :not_centos5?,
              :five?, :six?, :seven?,
              to: :centos_versioning

    def version
      @version ||= Utils::RedhatRelease.major_version(release_string)
    end

    def centos_versioning
      @centos_versioning ||= ::Utils::CentOSVersion.new(version)
    end

    private

    def release_string
      @release_string ||= `cat /etc/redhat-release`
    end
  end
end
