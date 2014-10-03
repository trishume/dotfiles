require 'rake'

desc "Hook our dotfiles into system-standard positions."
task :install do
  mac = `uname -s`.chomp == "Darwin"
  linkables = Dir.glob(mac ? '*/**{.symlink,.config}' : '*+/**{.symlink,.config}')

  skip_all = false
  overwrite_all = false
  backup_all = false

  linkables.each do |linkable|
    overwrite = false
    backup = false

    if linkable.include?('.config')
      file = linkable.split('/').last.split('.config').last
      target = "#{ENV["HOME"]}/.config/#{file}"
      puts "Linking config: #{target}"
    else
      file = linkable.split('/').last.split('.symlink').last
      target = "#{ENV["HOME"]}/.#{file}"
    end

    if File.exists?(target) || File.symlink?(target)
      next if skip_all
      unless skip_all || overwrite_all || backup_all
        puts "File already exists: #{target}, what do you want to do? [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all"
        case STDIN.gets.chomp
        when 'o' then overwrite = true
        when 'b' then backup = true
        when 'O' then overwrite_all = true
        when 'B' then backup_all = true
        when 'S' then skip_all = true
        when 's' then next
        end
      end
      FileUtils.rm_rf(target) if overwrite || overwrite_all
      `mv "#{target}" "#{target}.backup"` if backup || backup_all
    end
    `ln -s "$PWD/#{linkable}" "#{target}"`
  end
end

task :uninstall do

  Dir.glob('**/*.symlink').each do |linkable|

    file = linkable.split('/').last.split('.symlink').last
    target = "#{ENV["HOME"]}/.#{file}"

    # Remove all symlinks created during installation
    if File.symlink?(target)
      FileUtils.rm(target)
    end

    # Replace any backups made during installation
    if File.exists?("#{ENV["HOME"]}/.#{file}.backup")
      `mv "$HOME/.#{file}.backup" "$HOME/.#{file}"`
    end

  end
end

task :default => 'install'
