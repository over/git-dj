class GitDj
  require 'git_dj/version'
  INTEGRATION_BRANCH = 'staging'
  RELEASE_BRANCH = 'master'

  def initialize
  end

  def perform
    case ARGV[0]
    when 'integrate'
      integrate_current_branch
    when 'release'
      release_current_branch
    when 'help'
      print_help
    else
      print_help
    end
  end

  def integrate_current_branch
    cur_branch = current_branch_name
    if has_uncommited_changes
      puts red_color("Failed to integrate #{cur_branch}: you have uncommited changes")
    elsif cur_branch == INTEGRATION_BRANCH
      puts red_color("Can not integrate #{INTEGRATION_BRANCH} into #{INTEGRATION_BRANCH}")
    else
      run_cmds [
        "git checkout #{INTEGRATION_BRANCH}",
        "git merge #{cur_branch}",
        "git push origin #{INTEGRATION_BRANCH}",
        "git checkout #{cur_branch}"
      ]

      puts green_color("Successfully integrated #{cur_branch}")
    end
  end

  def release_current_branch
    cur_branch = current_branch_name
    if has_uncommited_changes
      puts red_color("Failed to release #{cur_branch}: you have uncommited changes")
    elsif cur_branch == RELEASE_BRANCH || cur_branch == INTEGRATION_BRANCH
      puts red_color("Can not integrate #{cur_branch} into #{RELEASE_BRANCH}")
    else
      run_cmds [
        "git checkout #{RELEASE_BRANCH}",
        "git merge #{cur_branch}",
        "git push origin #{RELEASE_BRANCH}",
        "git checkout #{cur_branch}"
      ]

      puts green_color("Successfully released #{cur_branch}")
    end
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

}
  end

private
  def has_uncommited_changes
    %x[git diff].chomp.strip != ''
  end

  def run_cmds(cmds)
    cmds.each do |cmd|
      system(cmd)
    end
  end

  def red_color(str)
    "\e[0;31m#{str}\e[m"
  end

  def green_color(str)
    "\e[0;32m#{str}\e[m"
  end

end

