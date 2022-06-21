List<User> users = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator'];
Group queue = [SELECT Id FROM Group WHERE Name = 'Trade reviewers' LIMIT 1];

List<GroupMember> groupMembers = new List<GroupMember>();
for (User user : users) {
    groupMembers.add(new GroupMember(GroupId = queue.Id, UserOrGroupId = user.Id));
}

insert groupMembers;