cuda() {
    if [ -z "$1" ]; then
        echo "Usage: cuda <device_ids>"
        echo "Example: cuda 1 or cuda 0,1,2"
        return 1
    fi

    export CUDA_VISIBLE_DEVICES="$1"
    echo "CUDA_VISIBLE_DEVICES set to: $CUDA_VISIBLE_DEVICES"
}

add_env() {
    local env_name="$1"
    local env_value="$2"
    local env_file="$HOME/.oh-my-zsh/custom/env.zsh"

    if [[ -z "$env_name" || -z "$env_value" ]]; then
        echo "Usage: add_env <ENV_NAME> <value>"
        echo "Example: add_env MY_VAR /path/to/dir"
        return 1
    fi

    echo "Adding $env_name to environment permanently..."

    mkdir -p "$(dirname "$env_file")"
    touch "$env_file"

    if ! grep -Fq "export $env_name=" "$env_file"; then
        echo "export $env_name=\"$env_value\"" >> "$env_file"
        export "$env_name"="$env_value"
        echo "Done! Reload shell or run: source $env_file"
    else
        echo "$env_name already exists in $env_file"
    fi
}

add_alias() {
    local alias_name="$1"
    local alias_cmd="$2"
    local alias_file="$HOME/.oh-my-zsh/custom/aliases.zsh"

    if [[ -z "$alias_name" || -z "$alias_cmd" ]]; then
        echo "Usage: add_alias <name> <command>"
        echo "Example: add_alias ll 'ls -lh'"
        echo "         add_alias myproj 'cd ~/projects/myproject'"
        return 1
    fi

    echo "Adding alias '$alias_name' permanently..."

    mkdir -p "$(dirname "$alias_file")"
    touch "$alias_file"

    if ! grep -Fq "alias $alias_name=" "$alias_file"; then
        echo "alias $alias_name='$alias_cmd'" >> "$alias_file"
        alias "$alias_name"="$alias_cmd"
        echo "Done! Reload shell or run: source $alias_file"
    else
        echo "Alias '$alias_name' already exists in $alias_file"
    fi
}

add_to_pythonpath() {
    local input="$1"
    local mode="$2"
    local env_file="$HOME/.oh-my-zsh/custom/env.zsh"
    local path

    if [[ -z "$input" ]]; then
        echo "Usage: add_to_pythonpath <path> [--permanent]"
        return 1
    fi

    # Resolve absolute path (zsh-safe, no realpath)
    if [[ -d "$input" ]]; then
        path="$(cd "$input" && pwd -P)"
    else
        echo "Error: '$input' is not a valid directory"
        return 1
    fi

    # Check if already in PYTHONPATH
    if [[ ":$PYTHONPATH:" == *":$path:"* ]]; then
        echo "$path is already in PYTHONPATH"
        return 0
    fi

    if [[ "$mode" == "--permanent" ]]; then
        echo "Adding $path to PYTHONPATH permanently..."

        mkdir -p "$(dirname "$env_file")"
        touch "$env_file"

        if ! grep -Fq "$path" "$env_file"; then
            echo "export PYTHONPATH=\"\$PYTHONPATH:$path\"" >> "$env_file"
        fi

        echo "Done! Restart your terminal or run:"
        echo "  source $env_file"
    else
        echo "Adding $path to this shell session..."
        export PYTHONPATH="$PYTHONPATH:$path"
    fi
}

install_dotfiles() {
    local dotfiles_dir="$HOME/.oh-my-zsh/custom/dotfiles"
    
    if [[ ! -d "$dotfiles_dir" ]]; then
        echo "No dotfiles directory found at $dotfiles_dir"
        return 1
    fi
    
    echo "Installing dotfiles from $dotfiles_dir..."
    
    for file in "$dotfiles_dir"/.* "$dotfiles_dir"/*; do
        # Skip . and .. directories
        [[ "$(basename "$file")" == "." || "$(basename "$file")" == ".." ]] && continue
        [[ ! -e "$file" ]] && continue
        
        local filename="$(basename "$file")"
        local target="$HOME/$filename"
        
        if [[ -e "$target" ]]; then
            echo "  $filename already exists, backing up to ${filename}.backup"
            mv "$target" "${target}.backup"
        fi
        
        echo "  Installing $filename"
        cp "$file" "$target"
    done
    
    echo "Done! Dotfiles installed."
}