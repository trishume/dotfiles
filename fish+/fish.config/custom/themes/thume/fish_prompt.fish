# name: bobthefish
#
# bobthefish is a Powerline-style, Git-aware fish theme optimized for awesome.
#
# You will probably need a Powerline-patched font for this to work:
#
#     https://powerline.readthedocs.org/en/latest/fontpatching.html
#
# I recommend picking one of these:
#
#     https://github.com/Lokaltog/powerline-fonts
#
# You can override some default options in your config.fish:
#
#     set -g theme_display_user yes
#     set -g default_user your_normal_user

set -g _thume_current_bg NONE

# Powerline glyphs
set _thume_branch_glyph            \u2B60
set _thume_ln_glyph                \u2B61
set _thume_padlock_glyph           \u2B64
set _thume_right_black_arrow_glyph \u2B80
set _thume_right_arrow_glyph       \u2B81
set _thume_left_black_arrow_glyph  \u2B82
set _thume_left_arrow_glyph        \u2B83

# Additional glyphs
set _thume_detached_glyph          \u27A6
set _thume_nonzero_exit_glyph      '! '
set _thume_superuser_glyph         '$ '
set _thume_bg_job_glyph            '% '

# Machine glyphs
set _thume_tbook_glyph  \u26A1\uFE0E
#set _thume_tbook_glyph  \u2318
set _thume_tbox_glyph  \u2601\uFE0E

if test $MACHINE = "TBox"
  set -g _thume_machine_glyph $_thume_tbox_glyph
else
  set -g _thume_machine_glyph $_thume_tbook_glyph
end

# Colors
set _thume_lt_green   brgreen
set _thume_med_green  green
set _thume_dk_green   0c4801

set _thume_lt_red     magenta
set _thume_med_red    yellow
set _thume_dk_red     yellow

set _thume_slate_blue blue

set _thume_lt_orange  yellow
set _thume_dk_orange  yellow

set _thume_dk_grey    black
set _thume_med_grey   839496
set _thume_lt_grey    white

set _pr_fg black
set _pr_dir_bg blue
set _pr_dir_low black

set _pr_clean_bg green
set _pr_dirty_bg yellow

# ===========================
# Helper methods
# ===========================

function _thume_in_git -d 'Check whether pwd is inside a git repo'
  command git rev-parse --is-inside-work-tree >/dev/null 2>&1
end

function _thume_git_branch -d 'Get the current git branch (or commitish)'
  set -l ref (command git symbolic-ref HEAD 2> /dev/null)
  if [ $status -gt 0 ]
    set -l branch (command git show-ref --head -s --abbrev |head -n1 2> /dev/null)
    set ref "$_thume_detached_glyph $branch"
  end
  echo $ref | sed  "s-refs/heads/-$_thume_branch_glyph -"
end

function _thume_pretty_parent -d 'Print a parent directory, shortened to fit the prompt'
  echo -n (dirname $argv[1]) | sed -e 's|/private||' -e "s|^$HOME|~|" -e 's-/\(\.\{0,1\}[^/]\)\([^/]*\)-/\1-g' -e 's|/$||'
end

function _thume_project_dir -d 'Print the current git project base directory'
  command git rev-parse --show-toplevel 2>/dev/null
end

function _thume_project_pwd -d 'Print the working directory relative to project root'
  set -l base_dir (_thume_project_dir)
  echo "$PWD" | sed -e "s*$base_dir**g" -e 's*^/**'
end


# ===========================
# Segment functions
# ===========================

function _thume_start_segment -d 'Start a prompt segment'
  set_color -b $argv[1]
  set_color $argv[2]
  if [ "$_thume_current_bg" = 'NONE' ]
    # If there's no background, just start one
    echo -n ' '
  else
    # If there's already a background...
    if [ "$argv[1]" = "$_thume_current_bg" ]
      # and it's the same color, draw a separator
      echo -n "$_thume_right_arrow_glyph "
    else
      # otherwise, draw the end of the previous segment and the start of the next
      set_color $_thume_current_bg
      echo -n "$_thume_right_black_arrow_glyph "
      set_color $argv[2]
    end
  end
  set _thume_current_bg $argv[1]
end

function _thume_path_segment -d 'Display a shortened form of a directory'
  if test -w "$argv[1]"
    _thume_start_segment $_pr_dir_bg $_pr_dir_low
  else
    _thume_start_segment $_thume_dk_red $_thume_lt_red
  end

  set -l directory
  set -l parent

  switch "$argv[1]"
    case /
      set directory '/'
    case "$HOME"
      set directory '~'
    case '*'
      #set parent    (_thume_pretty_parent "$argv[1]")
      #set parent    "$parent/"
      set directory (basename "$argv[1]")
      set directory "$directory/"
  end

  test "$parent"; and echo -n -s "$parent"
  echo -n "$directory "
  set_color normal
end

function _thume_finish_segments -d 'Close open prompt segments'
  if [ -n $_thume_current_bg -a $_thume_current_bg != 'NONE' ]
    set_color -b normal
    set_color $_thume_current_bg
    echo -n "$_thume_right_black_arrow_glyph "
    set_color normal
  end
  set -g _thume_current_bg NONE
end


# ===========================
# Theme components
# ===========================

function _thume_prompt_status -d 'Display symbols for a non zero exit status, root and background jobs'
  set -l nonzero
  set -l superuser
  set -l bg_jobs

  # Last exit was nonzero
  if [ $RETVAL -ne 0 ]
    set nonzero $_thume_nonzero_exit_glyph
  end

  # if superuser (uid == 0)
  set -l uid (id -u $USER)
  if [ $uid -eq 0 ]
    set superuser $_thume_superuser_glyph
  end

  # Jobs display
  if [ (jobs -l | wc -l) -gt 0 ]
    set bg_jobs $_thume_bg_job_glyph
  end

  set -l status_flags "$nonzero$superuser$bg_jobs"

  if test "$nonzero" -o "$superuser" -o "$bg_jobs"
    _thume_start_segment fff 000
    if [ "$nonzero" ]
      set_color $_thume_med_red --bold
      echo -n $_thume_nonzero_exit_glyph
    end

    if [ "$superuser" ]
      set_color $_thume_med_green --bold
      echo -n $_thume_superuser_glyph
    end

    if [ "$bg_jobs" ]
      set_color $_thume_slate_blue --bold
      echo -n $_thume_bg_job_glyph
    end

    set_color normal
  else
    _thume_start_segment white red
    echo -n "$_thume_machine_glyph "
  end
end

function _thume_prompt_user -d 'Display actual user if different from $default_user'
  if [ "$theme_display_user" = 'yes' ]
    if [ "$USER" != "$default_user" -o -n "$SSH_CLIENT" ]
      _thume_start_segment $_thume_lt_grey $_thume_slate_blue
      echo -n -s (whoami) '@' (hostname | cut -d . -f 1) ' '
    end
  end
end

function _thume_prompt_load -d 'Display load average if too high'
  set -l load1m (uptime | grep -o '[0-9]\+\.[0-9]\+' | head -n1)
  set -l load1m_test (math $load1m \* 100 / 1)
  if test $load1m_test -gt 100
    _thume_start_segment $_thume_lt_grey $_thume_slate_blue
    echo -n load:$load1m
  end
end

function _thume_prompt_time -d 'Display execution time if too high'
  if test $CMD_DURATION
    _thume_start_segment cyan $_thume_lt_grey
    echo -n "$CMD_DURATION "
  end
end

# TODO: clean up the fugly $ahead business
function _thume_prompt_git -d 'Display the actual git state'
  set -l dirty   (command git diff --no-ext-diff --quiet --exit-code; or echo -n '*')
  set -l staged  (command git diff --cached --no-ext-diff --quiet --exit-code; or echo -n '~')
  set -l stashed (command git rev-parse --verify refs/stash > /dev/null 2>&1; and echo -n '$')
  set -l ahead   (command git branch -v 2> /dev/null | grep -Eo '^\* [^ ]* *[^ ]* *\[[^]]*\]' | grep -Eo '\[[^]]*\]$' | awk 'ORS="";/ahead/ {print "+"} /behind/ {print "-"}' | sed -e 's/+-/±/')

  set -l new (command git ls-files --other --exclude-standard);
  test "$new"; and set new '…'

  set -l flags   "$dirty$staged$stashed$ahead$new"
  test "$flags"; and set flags " $flags"

  set -l flag_bg $_pr_clean_bg
  set -l flag_fg $_pr_fg
  if test "$dirty" -o "$staged"
    set flag_bg $_pr_dirty_bg
  else
    if test "$stashed"
      set flag_bg $_thume_lt_orange
    end
  end

  _thume_path_segment (_thume_project_dir)

  _thume_start_segment $flag_bg $flag_fg
  set_color $flag_fg
  echo -n -s (_thume_git_branch) $flags ' '
  set_color normal

  set -l project_pwd  (_thume_project_pwd)
  if test "$project_pwd"
    if test -w "$PWD"
      _thume_start_segment 333 999
    else
      _thume_start_segment $_thume_med_red $_thume_lt_red
    end

    echo -n -s $project_pwd ' '
  end
end

function _thume_prompt_dir -d 'Display a shortened form of the current directory'
  _thume_path_segment "$PWD"
end


# ===========================
# Apply theme
# ===========================

function fish_prompt -d 'Tristan theme, based on bobthefish'
  set -g RETVAL $status
  if test $TERM = "dumb"
    echo "\$ "
  else
    _thume_prompt_status
    _thume_prompt_time
    if _thume_in_git
      _thume_prompt_git
    else
      _thume_prompt_dir
    end
    _thume_finish_segments
  end
end
