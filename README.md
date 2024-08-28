# MentorshipPlatform Smart Contract

## Vision
To create a decentralized, transparent, and secure platform that connects students with mentors based on specific skill requirements, fostering personalized learning and professional growth.

## Overview
The MentorshipPlatform smart contract is a decentralized platform that allows mentors to offer their skills and students to select mentors based on their skill requirements. The contract facilitates the registration of mentors and students, matching based on skills, and transaction handling when a student selects a mentor.

## Features
- **Mentor Registration:** Mentors can register with their name and a list of skills they offer.
- **Student Registration:** Students can register with their name and a list of required skills.
- **Mentor Matching:** Students can view mentors that match their skill requirements and select a mentor.
- **Transaction Handling:** A fee is deducted from the student's balance and added to the mentor's balance when a student selects a mentor.
- **Withdrawal:** Mentors and students can withdraw their token balance.
- **Reset Functions:** Allows resetting of mentor availability and student match status.

## Smart Contract Details
- **Solidity Version:** ^0.8.0
- **License:** MIT

## Contract Functions

1. **registerMentor**
   - **Parameters:**
     - `string memory _name`: The name of the mentor.
     - `string[] memory _skills`: A list of skills that the mentor possesses.
   - **Description:** Registers a new mentor with their name and skills.
   - **Modifiers:**
     - `onlyUnregisteredMentor`: Ensures the mentor is not already registered.

2. **registerStudent**
   - **Parameters:**
     - `string memory _name`: The name of the student.
     - `string[] memory _requirements`: A list of skills that the student requires.
   - **Description:** Registers a new student with their name and skill requirements.
   - **Modifiers:**
     - `onlyUnregisteredStudent`: Ensures the student is not already registered.

3. **getMentorsBySkills**
   - **Parameters:**
     - `string[] memory _requiredSkills`: A list of skills that the student is looking for.
   - **Returns:** `address[]`: An array of mentor addresses that match the required skills.
   - **Description:** Retrieves a list of available mentors whose skills match the student's requirements.

4. **selectMentor**
   - **Parameters:**
     - `address _mentorAddress`: The address of the mentor to be selected.
   - **Description:** Allows a student to select a mentor based on skill match. Deducts a fee from the student's balance and adds it to the mentor's balance. Marks the mentor as unavailable and the student as matched.

5. **withdrawTokens**
   - **Parameters:** None
   - **Description:** Allows mentors or students to withdraw their token balance.

6. **resetMentorAvailability**
   - **Parameters:**
     - `address _mentorAddress`: The address of the mentor whose availability needs to be reset.
   - **Description:** Resets the mentor's availability status, allowing them to be selected by another student.

7. **resetStudentMatchStatus**
   - **Parameters:**
     - `address _studentAddress`: The address of the student whose match status needs to be reset.
   - **Description:** Resets the student's match status, allowing them to select another mentor.

## Events
- `MentorRegistered(address mentorAddress, uint256 mentorId, string name)`: Emitted when a new mentor is registered.
- `StudentRegistered(address studentAddress, uint256 studentId, string name)`: Emitted when a new student is registered.
- `MatchFound(address mentorAddress, address studentAddress, string[] matchedSkills)`: Emitted when a match is found between a mentor and a student.
- `TransactionCompleted(address studentAddress, address mentorAddress, uint256 amount)`: Emitted when a transaction is completed between a student and a mentor.
- `RewardGiven(address userAddress, uint256 amount)`: Emitted when tokens are rewarded or withdrawn.

## Usage
1. **Deploy the Contract:** Deploy the contract using Remix, Hardhat, or any other Ethereum development environment.
2. **Register as a Mentor or Student:** Use the `registerMentor` or `registerStudent` functions to register.
3. **Match and Select:** Students can find mentors with matching skills using the `getMentorsBySkills` function and select a mentor using the `selectMentor` function.
4. **Withdrawal:** Use the `withdrawTokens` function to withdraw available tokens.
5. **Resetting States:** Use `resetMentorAvailability` or `resetStudentMatchStatus` to reset the states.

## Example Scenario
1. A mentor registers with skills: `["Solidity", "Blockchain"]`.
2. A student registers with requirements: `["Blockchain"]`.
3. The student uses `getMentorsBySkills(["Blockchain"])` to find matching mentors.
4. The student selects a mentor by calling `selectMentor(mentorAddress)`.
5. A fee is deducted from the student's balance, and the mentor is rewarded.
6. The student and mentor can withdraw their tokens using the `withdrawTokens` function.

## Notes
- This contract does not handle real token transfers. Token transfer logic should be implemented using ERC20 standards for real-world applications.
- This is a simple proof of concept and does not include advanced features like multi-signature wallets, admin controls, or decentralized identity verification.

## Contact 
Name : Bikram Tripathi
Email : tripathbikram@gmail.com

## Deployment : 

Contract Address : 0x089a4f6dfcc411fed7c7af4fec00df7261e3062b
![image](https://github.com/user-attachments/assets/2aa8e387-3904-44ba-ab47-a9c18cf0d271)



## License
This project is licensed under the MIT License - see the LICENSE file for details.
