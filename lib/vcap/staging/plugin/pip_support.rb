module PipSupport

  REQUIREMENTS_FILE = 'requirements.txt'

  def uses_pip?
    File.exists?(File.join(source_directory, REQUIREMENTS_FILE))
  end

  def use_template_venv?
    File.exists?("/var/base-venv/")
  end

  def venv_dir
    File.join(app_dir, '.venv')
  end

  def setup_python_env
    if uses_pip?
      if use_template_venv?
        system "cp -r /var/base-venv/ #{venv_dir}"
      else
        system "pip install virtualenv"
        system "virtualenv --distribute #{venv_dir}"
      end
      system "#{File.join(venv_dir, 'bin', 'python')} #{File.join(venv_dir, 'bin', 'pip')} install --use-mirrors --download-cache=/var/pip-cache/ -r #{File.join(app_dir, 'requirements.txt')} > #{File.join(log_dir, 'staging.log')}"
      system "virtualenv --relocatable #{venv_dir}"
    end
  end

end
