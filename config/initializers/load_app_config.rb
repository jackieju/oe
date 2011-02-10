# read application.yml
    

        app_yaml_file = "#{RAILS_ROOT}/config/application.yml"
         p "==>load application config file from #{app_yaml_file}"
      if File.exist?(app_yaml_file)
      config = YAML.load(ERB.new(File.read(app_yaml_file)).result)
      if defined? RAILS_ENV
        config = config[RAILS_ENV]
      end
      Thread.current[:app_config] = config unless Thread.current[:app_config]
   
        ENV['server_name']=config['server_name']
        ENV['port']=config['port'].to_s
    end