module PipSupport

  REQUIREMENTS_FILE = 'requirements.txt'

  def uses_pip?
    File.exists?(File.join(source_directory, REQUIREMENTS_FILE))
  end

  # PEP 370 - user install area
  def user_base
    File.join(destination_directory, 'python')
  end

  def install_requirements
    system "#{File.join(source_directory, app_dir, '.venv', 'bin', 'pip')} install -r #{File.join(source_directory, app_dir)} requirements.txt >> ../logs/startup.log 2>&1"
  end

  def setup_python_env
    if uses_pip?
      system "pip install virtualenv"
      system "virtualenv --distribute #{File.join(source_directory, app_dir, '.venv')}"
      install_requirements
      system "virtualenv --relocatable #{File.join(source_directory, app_dir, '.venv')}"
    end
  end

end
