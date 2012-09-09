class GitDj
  VERSION = '0.0.1'

  def initialize
  end

  def perform
    case ARGV[0]
    when 'publish'
      integrate_current_branch
    when 'release'
      releast_current_branch
    when 'help'
      print_help
    else
      print_help
    end
  end

  def integrate_current_branch
  end

  def release_current_branch
  end

  def current_branch_name
    out = system('git branch')
    out.split("\n").each do |str|
    end
  end

  def print_help
    puts %Q{Git DJ #{VERSION}

Usage:
#{green_color('gdj integrate')} - merge current branch in staging branch, and switch back
#{green_color('gdj release')} - merge current branch into master, and switch back

Opts:
#{red_color('--deploy')} - call cap staging deploy after merge into staging, or cap production deploy after merge into production

}
  end

private
  def green_color(str)
    "\e[0;31m#{str}\e[m"
  end

  def red_color(str)
    "\e[0;32m#{str}\e[m"
  end

end

