// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MentorshipPlatform {
    struct Mentor {
        uint256 id;
        string name;
        string[] skills;
        uint256 balance;
        bool isAvailable;
    }

    struct Student {
        uint256 id;
        string name;
        string[] requirements;
        uint256 balance;
        bool isMatched;
    }

    mapping(address => Mentor) public mentors;
    mapping(address => Student) public students;
    address[] public mentorAddresses; // List to keep track of mentor addresses

    uint256 public mentorCount = 0;
    uint256 public studentCount = 0;
    uint256 public rewardAmount = 10; // Example token reward amount
    uint256 public mentorshipFee = 20; // Fee for selecting a mentor

    event MentorRegistered(address mentorAddress, uint256 mentorId, string name);
    event StudentRegistered(address studentAddress, uint256 studentId, string name);
    event MatchFound(address mentorAddress, address studentAddress, string[] matchedSkills);
    event TransactionCompleted(address studentAddress, address mentorAddress, uint256 amount);
    event RewardGiven(address userAddress, uint256 amount);

    modifier onlyUnregisteredMentor() {
        require(mentors[msg.sender].id == 0, "Already registered as a mentor.");
        _;
    }

    modifier onlyUnregisteredStudent() {
        require(students[msg.sender].id == 0, "Already registered as a student.");
        _;
    }

    // Register a new mentor with their skills
    function registerMentor(string memory _name, string[] memory _skills) public onlyUnregisteredMentor {
        mentorCount++;
        mentors[msg.sender] = Mentor(mentorCount, _name, _skills, 0, true);
        mentorAddresses.push(msg.sender); // Add mentor address to the list
        emit MentorRegistered(msg.sender, mentorCount, _name);
    }

    // Register a new student with their requirements
    function registerStudent(string memory _name, string[] memory _requirements) public onlyUnregisteredStudent {
        studentCount++;
        students[msg.sender] = Student(studentCount, _name, _requirements, 100, false); // Students start with a default balance of 100 tokens
        emit StudentRegistered(msg.sender, studentCount, _name);
    }

    // Get mentors by matching skill requirements
    function getMentorsBySkills(string[] memory _requiredSkills) public view returns (address[] memory) {
        address[] memory matchedMentors = new address[](mentorAddresses.length);
        uint256 matchCount = 0;

        for (uint256 i = 0; i < mentorAddresses.length; i++) {
            Mentor storage mentor = mentors[mentorAddresses[i]];
            if (mentor.isAvailable && hasMatchingSkills(mentor.skills, _requiredSkills)) {
                matchedMentors[matchCount] = mentorAddresses[i];
                matchCount++;
            }
        }

        // Resize the array to matchCount length
        address[] memory trimmedMatchedMentors = new address[](matchCount);
        for (uint256 j = 0; j < matchCount; j++) {
            trimmedMatchedMentors[j] = matchedMentors[j];
        }

        return trimmedMatchedMentors;
    }

    // Function for student to select a mentor from the list
    function selectMentor(address _mentorAddress) public {
        Student storage student = students[msg.sender];
        Mentor storage mentor = mentors[_mentorAddress];

        require(student.id != 0, "Student not registered.");
        require(mentor.id != 0, "Mentor not registered.");
        require(mentor.isAvailable, "Mentor is not available.");
        require(!student.isMatched, "Student is already matched.");
        require(hasMatchingSkills(mentor.skills, student.requirements), "Mentor does not have required skills.");
        require(student.balance >= mentorshipFee, "Insufficient balance to select a mentor.");

        // Perform the transaction
        student.balance -= mentorshipFee; // Deduct the mentorship fee from the student
        mentor.balance += mentorshipFee; // Add the mentorship fee to the mentor's balance

        // Mark the mentor as unavailable and the student as matched
        mentor.isAvailable = false;
        student.isMatched = true;

        // Emit events
        emit MatchFound(_mentorAddress, msg.sender, findMatchedSkills(mentor.skills, student.requirements));
        emit TransactionCompleted(msg.sender, _mentorAddress, mentorshipFee);
    }

    // Helper function to check if a mentor has matching skills
    function hasMatchingSkills(string[] memory _mentorSkills, string[] memory _studentRequirements) private pure returns (bool) {
        for (uint256 i = 0; i < _mentorSkills.length; i++) {
            for (uint256 j = 0; j < _studentRequirements.length; j++) {
                if (keccak256(abi.encodePacked(_mentorSkills[i])) == keccak256(abi.encodePacked(_studentRequirements[j]))) {
                    return true;
                }
            }
        }
        return false;
    }

    // Helper function to find matching skills between mentor and student
    function findMatchedSkills(string[] memory _mentorSkills, string[] memory _studentRequirements) private pure returns (string[] memory) {
        string[] memory matchedSkills = new string[](_mentorSkills.length);
        uint256 matchCount = 0;

        for (uint256 i = 0; i < _mentorSkills.length; i++) {
            for (uint256 j = 0; j < _studentRequirements.length; j++) {
                if (keccak256(abi.encodePacked(_mentorSkills[i])) == keccak256(abi.encodePacked(_studentRequirements[j]))) {
                    matchedSkills[matchCount] = _mentorSkills[i];
                    matchCount++;
                }
            }
        }

        // Resize the array to matchCount length
        string[] memory trimmedMatchedSkills = new string[](matchCount);
        for (uint256 k = 0; k < matchCount; k++) {
            trimmedMatchedSkills[k] = matchedSkills[k];
        }

        return trimmedMatchedSkills;
    }

    // Function to withdraw tokens by mentors or students
    function withdrawTokens() public {
        uint256 balance = mentors[msg.sender].balance + students[msg.sender].balance;
        require(balance > 0, "No tokens to withdraw.");

        if (mentors[msg.sender].balance > 0) {
            mentors[msg.sender].balance = 0;
        }
        if (students[msg.sender].balance > 0) {
            students[msg.sender].balance = 0;
        }

        // Transfer logic for tokens goes here (e.g., using ERC20 transfer)

        // Placeholder event for successful withdrawal
        emit RewardGiven(msg.sender, balance);
    }

    // Reset mentor availability (optional function to reset mentor state for new match)
    function resetMentorAvailability(address _mentorAddress) public {
        require(mentors[_mentorAddress].id != 0, "Mentor not registered.");
        mentors[_mentorAddress].isAvailable = true;
    }

    // Reset student match status (optional function to reset student state for new match)
    function resetStudentMatchStatus(address _studentAddress) public {
        require(students[_studentAddress].id != 0, "Student not registered.");
        students[_studentAddress].isMatched = false;
    }
}
