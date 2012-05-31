
class Licit::Command

  def run
    licenser = Licit::Licenser.new load_config
    if ARGV[0] == 'fix'
      fix licenser
    else
      check licenser
    end
  end

  def check(licenser)
    (licenser.check_files | licenser.check_headers).each do |severity, file, message|
      puts message
    end
  end

  def fix(licenser)
    licenser.fix_files
    licenser.fix_headers
  end

  def load_config
    config_file = find_file ['licit.yml', 'config/licit.yml']
    unless config_file
      puts "Could not find licit.yml config file"
      exit 1
    end
    YAML.load_file(config_file).each_with_object({}) { |(k,v), h| h[k.to_sym] = v }
  end

  def find_file probes
    probes.each do |file|
      return file if File.exist? file
    end
    nil
  end

end
