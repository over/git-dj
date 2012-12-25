class GitDj
  require 'git_dj/version'
  INTEGRATION_BRANCH = 'staging'
  RELEASE_BRANCH = 'master'
  LOG_FILE_NAME = '/tmp/gdj_activity'

  class CommandFailedError < StandardError; end;

  def initialize
  end

  def perform
    case ARGV[0]
    when 'integrate'
      integrate_current_branch
    when 'release'
      release_current_branch
    when 'get'
      get_updates_from_origin
    when 'put'
      push_updates_to_origin
    when 'continue'
      continue_prev_commands
    when 'help'
      print_help
    else
      print_help
    end
  end

  def integrate_current_branch
    drop_commands_cache
    cur_branch = current_branch_name
    if has_uncommited_changes
      puts red_color("Failed to integrate #{cur_branch}: you have uncommited changes")
    elsif cur_branch == INTEGRATION_BRANCH
      puts red_color("Can not integrate #{INTEGRATION_BRANCH} into #{INTEGRATION_BRANCH}")
    else
      run_cmds [
        "git checkout #{INTEGRATION_BRANCH}",
        "git merge #{cur_branch}",
        "git pull origin #{INTEGRATION_BRANCH}",
        "git push origin #{INTEGRATION_BRANCH}",
        "git checkout #{cur_branch}"
      ]

      puts green_color("Successfully integrated #{cur_branch}")
    end
  end

  def release_current_branch
    drop_commands_cache
    cur_branch = current_branch_name
    if has_uncommited_changes
      puts red_color("Failed to release #{cur_branch}: you have uncommited changes")
    elsif cur_branch == RELEASE_BRANCH || cur_branch == INTEGRATION_BRANCH
      puts red_color("Can not integrate #{cur_branch} into #{RELEASE_BRANCH}")
    else
      run_cmds [
        "git checkout #{RELEASE_BRANCH}",
        "git merge #{cur_branch}",
        "git pull origin #{RELEASE_BRANCH}",
        "git push origin #{RELEASE_BRANCH}",
        "git checkout #{cur_branch}"
      ]

      puts green_color("Successfully released #{cur_branch}")
    end
  end

  def continue_prev_commands
    cmds = File.read(LOG_FILE_NAME).chomp.strip.split("\n")
    run_cmds(cmds)
  end

  def get_updates_from_origin
    drop_commands_cache
    cur_branch = current_branch_name
    run_cmds [ "git pull origin #{cur_branch}" ]
  end

  def push_updates_to_origin
    drop_commands_cache
    cur_branch = current_branch_name
    run_cmds [
      "git pull origin #{cur_branch}",
      "git push origin #{cur_branch}"
    ]
  end

  def current_branch_name
    out = %x[git branch]
    branch_string = out.split("\n").detect do |str|
      str.index('*') == 0
    end


    branch_string.gsub!(/^\*/, '')
    branch_string.chomp.strip
  end

  def print_help
    puts %Q{Git DJ #{VERSION}

Usage:
#{green_color('gdj integrate')} - merge current branch in staging branch, and switch back
#{green_color('gdj release')} - merge current branch into master, and switch back
#{green_color('gdj get')} - pull changes from origin to local
#{green_color('gdj put')} - pull, then push changes from origin to local
#{green_color('gdj continue')} - continue previous failed command (after merge, etc)

}
  end

private

  def drop_commands_cache
    if File.exists?(LOG_FILE_NAME)
      FileUtils.rm(LOG_FILE_NAME)
    end
  end

  def has_uncommited_changes
    %x[git diff].chomp.strip != ''
  end

  def run_cmds(cmds)
    to_do = cmds.dup
    cmds.each do |cmd|
      if system(cmd)
        to_do.delete(cmd)
        dump_cmds_to_disk(to_do)
      else
        puts red_color("Command failed: #{cmd}.")
        puts red_color("Fix it and run gdj continue")
        raise CommandFailedError.new
      end
    end
  end

  def dump_cmds_to_disk(cmds)
    if cmds.any?
      File.open(LOG_FILE_NAME, 'w') {|f| f.write(cmds.join("\n")) }
    else
      drop_commands_cache
    end
  end

  def red_color(str)
    "\e[0;31m#{str}\e[m"
  end

  def green_color(str)
    "\e[0;32m#{str}\e[m"
  end

end


