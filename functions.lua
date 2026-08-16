function is_installed(pkg)
  local result = os.execute("command -v " .. pkg .. " > /dev/null 2>&1")
  return result == true or result == 0
end

function do_install_list(list)
  os.execute("sudo pacman -S --needed " .. table.concat(list, " "))
end

function copy_file(file, destination, name)
  os.execute("mkdir -p " .. destination)

  local target = destination .. name
  if os.execute("test -f " .. target) == 0 then
    os.execute("mv " .. target .. " " .. target .. ".old")
  end

  os.execute("sudo cp ./configs/" .. file .. " " .. target)
end
