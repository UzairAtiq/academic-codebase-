INCLUDE Irvine32.inc

; Prototypes
GuessGame        PROTO
GenerateNumber   PROTO
GetUserGuess     PROTO
CheckGuess       PROTO, secretNum:DWORD, guess:DWORD, lifeCountPtr:DWORD
PrintHistory     PROTO
UserManager      PROTO
AddUser          PROTO
SelectUser       PROTO
ResetGame        PROTO
StartGame        PROTO

; Data
.data
    ; messages
    msgInvalidGuess   BYTE "Invalid input! Please enter a numeric guess (1-100).",0
    msgWelcome        BYTE "=== Number Guessing Game ===",0
    msgStartNew       BYTE "Generating secret number...",0
    msgEnterGuess     BYTE "Enter your guess (1-100): ",0
    msgHigh           BYTE "Too High! Try Again.",0
    msgLow            BYTE "Too Low! Try Again.",0
    msgCorrect        BYTE "Correct! You guessed the number!",0
    msgGameOver       BYTE "Game Over! You've run out of lives.",0
    msgSecretNumber   BYTE "The secret number was: ",0
    msgAttempts       BYTE " Number of attempts: ",0
    msgScore          BYTE " Your score: ",0
    msgPlayAgain      BYTE "Do you want to play another game? (1 = Yes, 0 = No): ",0
    msgInvalidInput   BYTE "Invalid input. Enter 1 for Yes, 0 for No.",0
    msgHighScoreNow   BYTE "Current high score: ",0
    msgUserHighScore  BYTE "Your high score: ",0
    msgNewHigh        BYTE "Congratulations! New high score!",0
    msgHintEven       BYTE "Hint: The number is even.",0
    msgHintOdd        BYTE "Hint: The number is odd.",0
    msgLivesRemaining BYTE "Lives remaining: ",0
    msgOutOfLives     BYTE "You are out of lives!",0
    msgLifeLost       BYTE "Life lost! ",0
    
    ; Tutorial messages
    msgTutorialPrompt BYTE "Do you want to enable tutorial mode? (1 = Yes, 0 = No): ",0
    msgTutorialContent BYTE "Tutorial: Guess the number between 1 and 100.",0
    msgTutorialContent2 BYTE "You have only 5 lives! Each wrong guess costs 1 life.",0
    msgTutorialContent3 BYTE "Your score = (100 - attempts) * lives remaining.",0
    msgTutorialContent4 BYTE "Hints will be provided after 3 wrong guesses.",0
    
    ; User management messages
    msgUserManager    BYTE "=== User Manager ===",0
    msgAddUser        BYTE "1. Add New User",0
    msgSelectUser     BYTE "2. Select Existing User",0
    msgStartGameOpt   BYTE "3. Start Game",0
    msgExitUserMgr    BYTE "4. Exit",0
    msgChoice         BYTE "Enter choice (1-4): ",0
    msgEnterUserName  BYTE "Enter user name: ",0
    msgUserAdded      BYTE "User added successfully!",0
    msgUserSelected   BYTE "Selected user: ",0
    msgNoUsers        BYTE "No users exist. Please add a user first.",0
    msgUserList       BYTE "=== User List ===",0
    msgUserNum        BYTE "User ",0
    msgColon          BYTE ": ",0
    msgSelectUserNum  BYTE "Select user number: ",0
    msgCurrentUser    BYTE "Current User: ",0
    msgReturnToMenu   BYTE "Return to User Menu? (1 = Yes, 0 = Exit): ",0
    msgNoUserSelected BYTE "No user selected. Please select a user first.",0
    msgPressAnyKey    BYTE "Press any key to continue...",0
    
    newline         BYTE 0Dh,0Ah,0
    
    ; constants
    MAXUSERS        = 10
    MAXGAMES        = 20
    NAMELENGTH      = 20
    MAXLIVES        = 5         ; Maximum number of lives per game
    
    ; user structure
    USER STRUCT
        name        BYTE NAMELENGTH DUP(0)
        scores      DWORD MAXGAMES DUP(0)
        attempts    DWORD MAXGAMES DUP(0)
        livesUsed   DWORD MAXGAMES DUP(0)
        gameCount   DWORD 0
        highScore   DWORD 0
        gamesWon    DWORD 0
        gamesLost   DWORD 0
    USER ENDS
    
    ; user database
    users           USER MAXUSERS DUP(<>)
    userCount       DWORD 0
    currentUserId   DWORD 0FFFFFFFFh  ; Initialize as invalid
    
    ; per-game variables
    attemptCount    DWORD 0
    score           DWORD 0
    playAgain       DWORD 0
    tutorialMode    DWORD 0
    lifeCount       DWORD MAXLIVES
    secretNumber    DWORD 0
    gameWonFlag     DWORD 0

.code
main PROC
    ; initialize RNG
    call Randomize
    
    ; Start with User Manager
    call UserManager
    
ExitProgram:
    exit
main ENDP

; ResetGame - resets game variables
ResetGame PROC
    mov lifeCount, MAXLIVES
    mov attemptCount, 0
    mov score, 0
    mov gameWonFlag, 0
    ret
ResetGame ENDP

; UserManager - handles user selection/creation
UserManager PROC
MenuLoop:
    call Clrscr
    mov edx, OFFSET msgUserManager
    call WriteString
    call CrLf
    call CrLf
    
    mov edx, OFFSET msgAddUser
    call WriteString
    call CrLf
    mov edx, OFFSET msgSelectUser
    call WriteString
    call CrLf
    mov edx, OFFSET msgStartGameOpt
    call WriteString
    call CrLf
    mov edx, OFFSET msgExitUserMgr
    call WriteString
    call CrLf
    call CrLf
    
    mov edx, OFFSET msgChoice
    call WriteString
    call ReadInt
    
    cmp eax, 1
    je AddUserOption
    cmp eax, 2
    je SelectUserOption
    cmp eax, 3
    je StartGameOption
    cmp eax, 4
    je ExitManager
    
    ; Invalid input
    jmp MenuLoop

AddUserOption:
    call AddUser
    jmp MenuLoop

SelectUserOption:
    call SelectUser
    jmp MenuLoop

StartGameOption:
    call StartGame
    jmp MenuLoop

ExitManager:
    mov currentUserId, 0FFFFFFFFh
    ret
UserManager ENDP

; AddUser - adds a new user
AddUser PROC
    mov eax, userCount
    cmp eax, MAXUSERS
    jl CanAddUser
    
    ; Max users reached
    call CrLf
    mov edx, OFFSET msgInvalidInput
    call WriteString
    call CrLf
    mov edx, OFFSET msgPressAnyKey
    call WriteString
    call ReadChar
    ret

CanAddUser:
    call CrLf
    mov edx, OFFSET msgEnterUserName
    call WriteString
    
    ; Calculate user offset
    mov eax, TYPE USER
    mov ebx, userCount
    mul ebx
    mov edi, OFFSET users
    add edi, eax
    
    ; Read user name
    mov edx, edi
    mov ecx, NAMELENGTH
    call ReadString
    
    ; Initialize user data - FIXED: Don't use esi, use edi
    mov (USER PTR [edi]).gameCount, 0
    mov (USER PTR [edi]).highScore, 0
    mov (USER PTR [edi]).gamesWon, 0
    mov (USER PTR [edi]).gamesLost, 0
    
    inc userCount
    call CrLf
    mov edx, OFFSET msgUserAdded
    call WriteString
    call CrLf
    mov edx, OFFSET msgPressAnyKey
    call WriteString
    call ReadChar
    ret
AddUser ENDP

; SelectUser - displays and selects existing user
SelectUser PROC
    mov eax, userCount
    cmp eax, 0
    jg ShowUsers
    
    ; No users exist
    call CrLf
    mov edx, OFFSET msgNoUsers
    call WriteString
    call CrLf
    mov edx, OFFSET msgPressAnyKey
    call WriteString
    call ReadChar
    mov currentUserId, 0FFFFFFFFh
    ret

ShowUsers:
    call CrLf
    mov edx, OFFSET msgUserList
    call WriteString
    call CrLf
    call CrLf
    
    ; Display all users
    mov ecx, 0
DisplayLoop:
    cmp ecx, userCount
    jge GetSelection
    
    ; Display user number
    mov eax, ecx
    inc eax
    call WriteDec
    mov edx, OFFSET msgColon
    call WriteString
    
    ; Display user name
    mov eax, TYPE USER
    mul ecx
    mov esi, OFFSET users
    add esi, eax
    mov edx, esi
    call WriteString
    
    ; Display high score
    mov edx, OFFSET msgHighScoreNow
    call WriteString
    mov eax, (USER PTR [esi]).highScore
    call WriteDec
    
    ; Display win/loss ratio
    mov edx, OFFSET msgAttempts
    call WriteString
    mov eax, (USER PTR [esi]).gamesWon
    call WriteDec
    mov al, '/'
    call WriteChar
    mov eax, (USER PTR [esi]).gamesLost
    call WriteDec
    call CrLf
    
    inc ecx
    jmp DisplayLoop

GetSelection:
    call CrLf
    mov edx, OFFSET msgSelectUserNum
    call WriteString
    call ReadInt
    dec eax  ; convert to 0-based index
    
    ; Validate selection
    cmp eax, 0
    jl InvalidSelection
    cmp eax, userCount
    jge InvalidSelection
    
    mov currentUserId, eax
    
    ; Display selection message
    call CrLf
    mov edx, OFFSET msgUserSelected
    call WriteString
    
    mov eax, TYPE USER
    mul currentUserId
    mov esi, OFFSET users
    add esi, eax
    mov edx, esi
    call WriteString
    call CrLf
    mov edx, OFFSET msgPressAnyKey
    call WriteString
    call ReadChar
    ret

InvalidSelection:
    mov edx, OFFSET msgInvalidInput
    call WriteString
    call CrLf
    mov edx, OFFSET msgPressAnyKey
    call WriteString
    call ReadChar
    mov currentUserId, 0FFFFFFFFh
    ret
SelectUser ENDP

; StartGame - starts the game if a user is selected
StartGame PROC
    ; Check if a user is selected
    mov eax, currentUserId
    cmp eax, 0FFFFFFFFh
    jne UserSelected
    
    ; No user selected
    call CrLf
    mov edx, OFFSET msgNoUserSelected
    call WriteString
    call CrLf
    mov edx, OFFSET msgPressAnyKey
    call WriteString
    call ReadChar
    ret
    
UserSelected:
    ; Display current user info
    call CrLf
    mov edx, OFFSET msgCurrentUser
    call WriteString
    
    ; Calculate user offset
    mov eax, TYPE USER
    mov ebx, currentUserId
    mul ebx
    mov esi, OFFSET users
    add esi, eax
    
    ; Display user name
    mov edx, esi
    call WriteString
    call CrLf
    
    ; Display user statistics
    mov edx, OFFSET msgUserHighScore
    call WriteString
    mov eax, (USER PTR [esi]).highScore
    call WriteDec
    call CrLf
    
    ; Display games won/lost
    mov edx, OFFSET msgAttempts
    call WriteString
    mov eax, (USER PTR [esi]).gamesWon
    call WriteDec
    mov al, '/'
    call WriteChar
    mov eax, (USER PTR [esi]).gamesLost
    call WriteDec
    call CrLf
    call CrLf
    
    ; ask for tutorial mode
    mov edx, OFFSET msgTutorialPrompt
    call WriteString
    call ReadInt
    cmp eax, 1
    jne SkipTutorial
    mov tutorialMode, 1
    
    ; display tutorial content
    mov edx, OFFSET msgTutorialContent
    call WriteString
    call CrLf
    mov edx, OFFSET msgTutorialContent2
    call WriteString
    call CrLf
    mov edx, OFFSET msgTutorialContent3
    call WriteString
    call CrLf
    mov edx, OFFSET msgTutorialContent4
    call WriteString
    call CrLf
    call CrLf

SkipTutorial:
    ; display welcome
    mov edx, OFFSET msgWelcome
    call WriteString
    call CrLf
    
GamePlayLoop:
    ; start game for current user
    call GuessGame
    
    ; show user's history
    call PrintHistory
    
    ; ask to play another game with same user
    call CrLf
    mov edx, OFFSET msgPlayAgain
    call WriteString
    call ReadInt
    cmp eax, 1
    je GamePlayLoop  ; Play another game with same user
    
    ; Return to user menu
    ret
StartGame ENDP

; GuessGame - main game procedure with limited lives
GuessGame PROC USES ebx esi edi
    LOCAL localLifeCount:DWORD
    LOCAL localSecretNumber:DWORD
    
    ; Get current user's data
    mov eax, currentUserId
    cmp eax, 0FFFFFFFFh
    je EndGame  ; No user selected
    
    ; Calculate user offset
    mov eax, TYPE USER
    mov ebx, currentUserId
    mul ebx
    mov esi, OFFSET users
    add esi, eax

GameStart:
    ; Reset game variables
    call ResetGame
    mov localLifeCount, MAXLIVES
    
    mov edx, OFFSET msgStartNew
    call WriteString
    call CrLf

    call GenerateNumber
    mov localSecretNumber, eax
    mov ebx, eax            ; secret number
    
    ; Display initial lives
    call CrLf
    mov edx, OFFSET msgLivesRemaining
    call WriteString
    mov eax, localLifeCount
    call WriteDec
    call CrLf
    call CrLf

GameLoop:
    ; Check if out of lives
    mov eax, localLifeCount
    cmp eax, 0
    jle GameOver
    
    call GetUserGuess
    inc attemptCount
    mov edi, eax            ; store guess

    ; Check guess
    INVOKE CheckGuess, ebx, edi, ADDR localLifeCount
    
    ; Check if correct guess
    cmp eax, 0
    je CorrectGuess
    
    ; Wrong guess - decrement life
    dec localLifeCount
    jmp AfterLifeUpdate

CorrectGuess:
    mov gameWonFlag, 1

AfterLifeUpdate:
    ; Display lives remaining
    call CrLf
    mov edx, OFFSET msgLivesRemaining
    call WriteString
    mov eax, localLifeCount
    call WriteDec
    call CrLf
    
    ; Check game state
    cmp gameWonFlag, 1
    je GameWon
    mov eax, localLifeCount
    cmp eax, 0
    jg GameLoop
    
GameOver:
    ; Player lost
    call CrLf
    mov edx, OFFSET msgGameOver
    call WriteString
    call CrLf
    mov edx, OFFSET msgSecretNumber
    call WriteString
    mov eax, localSecretNumber
    call WriteDec
    call CrLf
    
    ; Update user's lost games
    inc (USER PTR [esi]).gamesLost
    
    ; Calculate score (0 for loss)
    mov score, 0
    jmp EndGameRound

GameWon:
    ; Player won
    mov edx, OFFSET msgCorrect
    call WriteString
    call CrLf
    
    ; Calculate score: (100 - attempts) * lives remaining
    mov eax, 100
    mov ecx, attemptCount
    sub eax, ecx
    cmp eax, 0
    jge PositiveScore
    mov eax, 0
PositiveScore:
    mov ebx, localLifeCount
    mul ebx
    mov score, eax
    
    ; Update user's won games
    inc (USER PTR [esi]).gamesWon

EndGameRound:
    ; show attempts & score
    mov edx, OFFSET msgAttempts
    call WriteString
    mov eax, attemptCount
    call WriteDec
    call CrLf

    mov edx, OFFSET msgScore
    call WriteString
    mov eax, score
    call WriteDec
    call CrLf

    ; store game data for this user
    mov eax, (USER PTR [esi]).gameCount
    cmp eax, MAXGAMES
    jge SkipStore
    
    ; Store attempts
    mov ecx, eax
    lea edx, (USER PTR [esi]).attempts
    mov ebx, attemptCount
    mov [edx + ecx*4], ebx
    
    ; Store score
    lea edx, (USER PTR [esi]).scores
    mov ebx, score
    mov [edx + ecx*4], ebx
    
    ; Store lives used
    lea edx, (USER PTR [esi]).livesUsed
    mov ebx, MAXLIVES
    sub ebx, localLifeCount
    mov [edx + ecx*4], ebx
    
    ; Update user's game count
    inc (USER PTR [esi]).gameCount

SkipStore:
    ; Update user's high score only if won
    cmp gameWonFlag, 1
    jne ShowUserHigh
    
    mov eax, score
    cmp eax, (USER PTR [esi]).highScore
    jle ShowUserHigh
    mov (USER PTR [esi]).highScore, eax
    mov edx, OFFSET msgNewHigh
    call WriteString
    call CrLf

ShowUserHigh:
    mov edx, OFFSET msgUserHighScore
    call WriteString
    mov eax, (USER PTR [esi]).highScore
    call WriteDec
    call CrLf
    call CrLf

EndGame:
    ret
GuessGame ENDP

; GenerateNumber: returns random number 1..100
GenerateNumber PROC
    mov eax, 100
    call RandomRange
    inc eax
    ret
GenerateNumber ENDP

; GetUserGuess - prompt & read int (1-100) with validation
GetUserGuess PROC
ReadGuess:
    mov edx, OFFSET msgEnterGuess
    call WriteString
    call ReadInt
    jno CheckRange  ; Check for overflow
    
InvalidInput:
    mov edx, OFFSET msgInvalidGuess
    call WriteString
    call CrLf
    jmp ReadGuess
    
CheckRange:
    cmp eax, 1
    jl InvalidInput
    cmp eax, 100
    jg InvalidInput
    ret
GetUserGuess ENDP

; CheckGuess(secret, guess, lifeCountPtr) - returns 0 if correct, 1 if wrong
CheckGuess PROC USES ebx esi, secretNum:DWORD, guess:DWORD, lifeCountPtr:DWORD
    mov eax, guess
    mov ebx, secretNum
    cmp eax, ebx
    je Correct
    
    ; Wrong guess - show message based on high/low
    ja TooHigh
    
    ; Too low
    mov edx, OFFSET msgLow
    call WriteString
    mov edx, OFFSET msgLifeLost
    call WriteString
    call CrLf
    mov eax, 1
    ret
    
TooHigh:
    ; Too high
    mov edx, OFFSET msgHigh
    call WriteString
    mov edx, OFFSET msgLifeLost
    call WriteString
    call CrLf
    mov eax, 1
    ret
    
Correct:
    mov edx, OFFSET msgCorrect
    call WriteString
    call CrLf
    mov eax, 0
    ret
CheckGuess ENDP

; PrintHistory - displays game history for current user
PrintHistory PROC USES esi
    ; Check if user is selected
    mov eax, currentUserId
    cmp eax, 0FFFFFFFFh
    je NoHistory
    
    ; Calculate user offset
    mov eax, TYPE USER
    mov ebx, currentUserId
    mul ebx
    mov esi, OFFSET users
    add esi, eax

    mov eax, (USER PTR [esi]).gameCount
    cmp eax, 0
    je NoHistory

    call CrLf
    mov edx, OFFSET msgWelcome
    call WriteString
    call CrLf
    
    ; Display user name and stats
    mov edx, OFFSET msgCurrentUser
    call WriteString
    mov edx, esi
    call WriteString
    call CrLf
    
    mov edx, OFFSET msgUserHighScore
    call WriteString
    mov eax, (USER PTR [esi]).highScore
    call WriteDec
    call CrLf
    
    ; Display games won/lost
    mov edx, OFFSET msgAttempts
    call WriteString
    mov eax, (USER PTR [esi]).gamesWon
    call WriteDec
    mov al, '/'
    call WriteChar
    mov eax, (USER PTR [esi]).gamesLost
    call WriteDec
    mov edx, OFFSET msgScore
    call WriteString
    call CrLf
    call CrLf

    ; Display game history header
    mov edx, OFFSET msgUserList
    call WriteString
    call CrLf
    
    mov ecx, 0
PrintLoop:
    mov eax, ecx
    cmp eax, (USER PTR [esi]).gameCount
    jge DoneHistory

    mov edx, OFFSET newline
    call WriteString
    
    ; Game number
    mov eax, ecx
    inc eax
    call WriteDec
    mov al, '.'
    call WriteChar
    mov al, ' '
    call WriteChar
    
    ; Status (Won/Lost)
    lea ebx, (USER PTR [esi]).scores
    mov eax, [ebx + ecx*4]
    cmp eax, 0
    jle LostGame
    mov al, 'W'
    call WriteChar
    mov al, ' '
    call WriteChar
    jmp ShowDetails
LostGame:
    mov al, 'L'
    call WriteChar
    mov al, ' '
    call WriteChar
    
ShowDetails:
    ; Attempts
    mov edx, OFFSET msgAttempts
    call WriteString
    lea ebx, (USER PTR [esi]).attempts
    mov eax, [ebx + ecx*4]
    call WriteDec
    
    ; Lives used
    mov al, ' '
    call WriteChar
    mov al, '('
    call WriteChar
    lea ebx, (USER PTR [esi]).livesUsed
    mov eax, [ebx + ecx*4]
    call WriteDec
    mov al, '/'
    call WriteChar
    mov eax, MAXLIVES
    call WriteDec
    mov al, ')'
    call WriteChar
    
    ; Score
    mov edx, OFFSET msgScore
    call WriteString
    lea ebx, (USER PTR [esi]).scores
    mov eax, [ebx + ecx*4]
    call WriteDec
    
    call CrLf
    inc ecx
    jmp PrintLoop

DoneHistory:
    call CrLf
    ret

NoHistory:
    call CrLf
    mov edx, OFFSET msgNoUsers
    call WriteString
    call CrLf
    ret
PrintHistory ENDP

END main