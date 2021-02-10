# Theme thats compatible with the bash PS1 from Linux Mint but adds support for return codes and git

# SETTINGS
EXTENDED=1 #set to 1 to have a extended shell

# CODE
local return_code="%(?..%? )"
local user="%(#..%n@)"
local usercode="%(#.#.$)"
local coloruserhost="%(#.%{$fg_bold[red]%}.%{$fg_bold[green]%})"

PROMPT='${coloruserhost}${user}%M%{$reset_color%}:%{$fg_bold[blue]%}%~ ${usercode}%{$reset_color%} '
if (( $EXTENDED == 1 )) ; then
	function my_git_prompt_info() {
		ref=$(git symbolic-ref HEAD 2> /dev/null) || return
		GIT_STATUS=$(git_prompt_status)
		[[ -n $GIT_STATUS ]] && GIT_STATUS=" $GIT_STATUS"
		echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$GIT_STATUS$ZSH_THEME_GIT_PROMPT_SUFFIX"
	}
	function my_ssh_connection() {
		if ! [[ -z $SSH_CONNECTION ]] ; then
			SSH_SPLIT=("${(s/ /)SSH_CONNECTION}")
			echo "%{$fg[red]%}$SSH_SPLIT[1]%{$reset_color%}→%{$fg[red]%}$SSH_SPLIT[3]%{$reset_color%}:%{$fg[red]%}$SSH_SPLIT[4]%{$reset_color%}"
		fi
	}

	ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[cyan]%}("
	ZSH_THEME_GIT_PROMPT_SUFFIX=") %{$reset_color%}"
	ZSH_THEME_GIT_PROMPT_UNTRACKED="%%"
	ZSH_THEME_GIT_PROMPT_ADDED="+"
	ZSH_THEME_GIT_PROMPT_MODIFIED="*"
	ZSH_THEME_GIT_PROMPT_RENAMED="~"
	ZSH_THEME_GIT_PROMPT_DELETED="!"
	ZSH_THEME_GIT_PROMPT_UNMERGED="?"

	PROMPT="${return_code}${PROMPT}"
	RPS1='$(my_git_prompt_info) $(my_ssh_connection)'
fi
