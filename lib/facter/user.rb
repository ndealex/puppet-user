
users_file = '/etc/passwd'
group_file = '/etc/group'

Facter.add(:system_users) do
  setcode do
    users = {}
    if File.readable?(users_file) then
      File.open(users_file, 'r') do |lines|
        lines.each do |line|
          result = line.split(":")
          # 0 - username
          # 1 - x
          # 2 - uid
          # 3 - gid
          # 4 - GECOS
          # 5 - Home
          # 6 - Shell
          users[result[0]]={"uid"=>result[2], "gid"=>result[3], "desc"=>result[4], "home"=>result[5], "shell"=>result[6].strip!}
        end
      end
    end
    users
  end
end

Facter.add(:system_groups) do
  setcode do
    groups = {}
    if File.readable?(group_file) then
      File.open(group_file, 'r') do |lines|
        lines.each do |line|
          result = line.split(":")
          # 0 - groupname
          # 1 - x
          # 2 - gid
          # 3 - members
          groups[result[0]] = {"gid"=>result[2],"members"=>result[3].split(",").map!(&:strip).reject{|g| g == ""} }
        end
      end
    end
    groups
  end
end
