class DjangoPlugin < StagingPlugin
  include PipSupport

  def stage_application
    Dir.chdir(destination_directory) do
      create_app_directories
      copy_source_files
      setup_python_env
      create_startup_script
      create_stop_script
      create_gunicorn_config
    end
  end

  def start_command
    cmds = []
    cmds << "python manage.py syncdb --noinput >> ../logs/syncdb.log 2>&1"
    cmds << "gunicorn_django -c ../gunicorn.config"
    cmds.join("\n")
  end

  private

  def startup_script
    vars = {}
    #setup python scripts to sync stdout/stderr to files
    vars['PYTHONUNBUFFERED'] = "true"
    vars['PATH'] = "$PATH:$PWD/app/.venv/bin/"
    generate_startup_script(vars)
  end

  def stop_script
    generate_stop_script
  end

  def create_gunicorn_config
    File.open('gunicorn.config', 'w') do |f|
      f.write <<-EOT
import os
bind = "0.0.0.0:%s" % os.environ['VCAP_APP_PORT']
loglevel = "debug"
      EOT
    end
  end
end
