
users_file = '/etc/passwd'
group_file = '/etc/group'

Facter.add(:sl_users) do
  setcode do
    users = []
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
          if result[2].to_i > 9999 && result[2].to_i < 65534 then
            users << result[0]
          end
        end
      end
    end
    users.join(',')
  end
end

Facter.add(:sl_groups) do
  setcode do
    groups = []
    if File.readable?(group_file) then
      File.open(group_file, 'r') do |lines|
        lines.each do |line|
          result = line.split(":")
          # 0 - groupname
          # 1 - x
          # 2 - gid
          # 3 - members
          if result[2].to_i > 9999 && result[2].to_i < 65534 then
            groups << result[0]
          end
        end
      end
    end
    groups.join(',')
  end
end
