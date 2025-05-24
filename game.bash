#!/bin/bash

VERSION="2.8"
STATS_FILE="$HOME/.xtype_stats"

BOLD='\033[1m'
BLINK='\033[5m'
NC='\033[0m'

RED='\033[38;5;196m'
GREEN='\033[38;5;46m'
YELLOW='\033[38;5;226m'
BLUE='\033[38;5;39m'
PURPLE='\033[38;5;129m'
CYAN='\033[38;5;51m'

show_header() {
    clear
    echo -e "${PURPLE}"
    echo " ██╗  ██╗████████╗██╗   ██╗██████╗ ███████╗"
    echo " ╚██╗██╔╝╚══██╔══╝╚██╗ ██╔╝██╔══██╗██╔════╝"
    echo "  ╚███╔╝    ██║    ╚████╔╝ ██████╔╝█████╗  "
    echo "  ██╔██╗    ██║     ╚██╔╝  ██╔═══╝ ██╔══╝  "
    echo " ██╔╝ ██╗   ██║      ██║   ██║     ███████╗"
    echo " ╚═╝  ╚═╝   ╚═╝      ╚═╝   ╚═╝     ╚══════╝"
    echo -e "${NC}${BOLD}                    v$VERSION${NC}\n"
}

EASY=(
    "The quick brown fox jumps over the lazy dog."
    "Hello world! Let's begin typing."
    "Bash scripting can be fun and useful."
    "Practice makes perfect for typing skills."
    "Start slow and focus on accuracy first."
    "Keep calm and code on."
    "Programming is the art of telling another human what one wants the computer to do."
    "The best way to learn is by doing."
    "Every expert was once a beginner."
    "Simple is better than complex."
)

MEDIUM=(
    "The five boxing wizards jump quickly."
    "UNIX philosophy: do one thing well."
    "Command line skills boost productivity."
    "Typing speed improves with consistent practice."
    "Algorithmic complexity affects program performance."
    "Linux is the best operating system for developers."
    "Open source software powers the modern internet."
    "Version control is essential for team collaboration."
    "Debugging is twice as hard as writing the code in the first place."
    "Premature optimization is the root of all evil."
)

HARD=(
    "Quantum mechanics challenges classical physics paradigms."
    "Cryptographic hash functions require collision resistance properties."
    "Distributed systems face CAP theorem tradeoffs and consistency models."
    "Neural networks utilize backpropagation for gradient descent optimization."
    "Type theory influences programming language design and implementation."
    "The halting problem demonstrates the limits of computability."
    "Monads are monoids in the category of endofunctors."
    "Concurrent programming requires careful synchronization."
    "The P versus NP problem remains unsolved in computer science."
    "Lambda calculus forms the basis of functional programming."
)

LONG=(
    "In software engineering, the mediator pattern defines an object that encapsulates how a set of objects interact, promoting loose coupling by keeping objects from referring to each other explicitly, allowing their interaction to vary independently. This pattern is particularly useful when dealing with complex communication protocols between multiple components."
    "The fundamental theorem of calculus states that differentiation and integration are inverse operations: if a continuous function is first integrated and then differentiated, the original function is retrieved. This theorem links the concept of the derivative of a function with the concept of the integral of a function."
    "Monads in functional programming are structures that represent computations defined as sequences of steps. They allow programmers to build pipelines that process data in steps, encapsulating side effects while maintaining referential transparency. The monad determines how combined functions form a new computation."
)

init_stats() {
    [ ! -f "$STATS_FILE" ] && echo -e "wpm=0\nbest=0\nsessions=0\ntotal_chars=0\ntotal_correct=0\ntotal_accuracy=0" > "$STATS_FILE"
}

load_stats() {
    source "$STATS_FILE" 2>/dev/null || { wpm=0; best=0; sessions=0; total_chars=0; total_correct=0; total_accuracy=0; }
}

save_stats() {
    echo -e "wpm=$wpm\nbest=$best\nsessions=$sessions\ntotal_chars=$total_chars\ntotal_correct=$total_correct\ntotal_accuracy=$total_accuracy" > "$STATS_FILE"
}

progress_bar() {
    local width=30
    local completion=$((100 * ${#typed} / ${#prompt}))
    [ $completion -gt 100 ] && completion=100
    local filled=$((width * ${#typed} / ${#prompt}))
    [ $filled -gt $width ] && filled=$width
    
    printf "["
    for ((i=0; i<width; i++)); do
        [ $i -lt $filled ] && printf "▓" || printf "░"
    done
    printf "] %3d%%\r" $completion
}

play_game() {
    load_stats
    prompt=$(get_prompt)
    words=$(echo "$prompt" | wc -w)
    
    show_header
    echo -e "${BLUE}Type this text:${NC}\n\n${YELLOW}$prompt${NC}\n"
    echo -e "${GREEN}Press any key to start...${NC}"
    read -n1 -s
    
    start=$(date +%s)
    typed=""
    correct_chars=0
    current_wpm=0
    last_update=$(date +%s.%N)
    
    while true; do
        now=$(date +%s.%N)
        elapsed=$(echo "$now - $start" | bc)
        
        current_chars=$(echo "$correct_chars / 5" | bc)
        current_wpm=$(echo "scale=2; $current_chars * 60 / $elapsed" | bc)
        [ -z "$current_wpm" ] && current_wpm=0
        
        echo -en "\r${CYAN}WPM: ${BOLD}$current_wpm${NC} "
        progress_bar
        
        if [ ${#typed} -ge ${#prompt} ]; then
            correct_chars=0
            for ((i=0; i<${#prompt}; i++)); do
                [ "${typed:$i:1}" = "${prompt:$i:1}" ] && ((correct_chars++))
            done
            
            end=$(date +%s)
            total=$((end - start))
            final_wpm=$(( (words * 60) / (total > 0 ? total : 1) ))
            accuracy=$((100 * correct_chars / (${#prompt} > 0 ? ${#prompt} : 1) ))
            
            ((total_chars+=${#prompt}))
            ((total_correct+=correct_chars))
            total_accuracy=$((100 * total_correct / (total_chars > 0 ? total_chars : 1) ))
            [ $final_wpm -gt $best ] && best=$final_wpm
            wpm=$(( (wpm * sessions + final_wpm) / (sessions + 1) ))
            ((sessions++))
            save_stats
            
            echo -e "\n\n${PURPLE}=== Results ==="
            echo -e "${CYAN}Time:${NC} $total seconds"
            echo -e "${CYAN}WPM:${NC} ${BOLD}$final_wpm${NC}"
            echo -e "${CYAN}Accuracy:${NC} ${BOLD}$accuracy%${NC}"
            echo -e "${CYAN}Best WPM:${NC} ${BOLD}$best${NC}${PURPLE}"
            echo -e "=============${NC}\n"
            
            if [ $accuracy -eq 100 ]; then
                echo -e "${GREEN}${BLINK}Perfect! No errors.${NC}"
            else
                echo -e "${RED}Completed with $(( ${#prompt} - correct_chars )) mistakes.${NC}"
            fi
            
            read -n1 -s -p "$(echo -e ${BLUE}"Press any key to continue..."${NC})"
            return
        fi
        
        if IFS= read -n1 -s -t 0.05 char; then
            if [ "$char" = $'\x7f' ]; then
                [ ${#typed} -gt 0 ] && typed="${typed%?}"
            else
                [ -z "$char" ] && char=" "
                typed+="$char"
                [ "${typed: -1}" = "${prompt:$((${#typed}-1)):1}" ] && ((correct_chars++))
            fi
            
            show_header
            echo -e "${BLUE}Type this text:${NC}\n"
            for ((i=0; i<${#prompt}; i++)); do
                if [ $i -lt ${#typed} ]; then
                    [ "${typed:$i:1}" = "${prompt:$i:1}" ] && 
                        echo -en "${GREEN}${prompt:$i:1}${NC}" || 
                        echo -en "${RED}${prompt:$i:1}${NC}"
                else
                    echo -en "${YELLOW}${prompt:$i:1}${NC}"
                fi
            done
            echo -e "\n"
        fi
    done
}

get_prompt() {
    load_stats
    if [ $sessions -lt 3 ]; then  # First 3 sessions always easy
        echo "${EASY[$RANDOM % ${#EASY[@]}]}"
    else
        if (( $(echo "$wpm >= 60 && $total_accuracy >= 85" | bc -l) )); then
            # 20% chance of long prompt if qualified
            if (( RANDOM % 5 == 0 )); then
                echo "${LONG[$RANDOM % ${#LONG[@]}]}"
            else
                echo "${HARD[$RANDOM % ${#HARD[@]}]}"
            fi
        elif (( $(echo "$wpm >= 40" | bc -l) )); then
            echo "${HARD[$RANDOM % ${#HARD[@]}]}"
        elif (( $(echo "$wpm >= 25" | bc -l) )); then
            echo "${MEDIUM[$RANDOM % ${#MEDIUM[@]}]}"
        else
            # 30% chance of medium even at low WPM
            if (( RANDOM % 3 == 0 )); then
                echo "${MEDIUM[$RANDOM % ${#MEDIUM[@]}]}"
            else
                echo "${EASY[$RANDOM % ${#EASY[@]}]}"
            fi
        fi
    fi
}

main_menu() {
    init_stats
    while true; do
        show_header
        load_stats
        
        echo -e "${BOLD}${CYAN}1. ${GREEN}Play Game"
        echo -e "${CYAN}2. ${YELLOW}View Stats"
        echo -e "${CYAN}3. ${RED}Exit"
        echo -en "\n${PURPLE}Select: ${NC}${BOLD}"
        
        read -n1 choice
        echo -e "${NC}"
        
        case "$choice" in
            1) play_game ;;
            2) show_header
               echo -e "${CYAN}Your Stats:"
               echo -e "${GREEN}Current WPM: $wpm"
               echo -e "Best WPM: $best"
               echo -e "Sessions: $sessions"
               echo -e "Overall Accuracy: $total_accuracy%${NC}"
               read -n1 -s -p "$(echo -e ${BLUE}"\nPress any key..."${NC})"
               ;;
            3) echo -e "${PURPLE}Thanks for playing!${NC}"; exit 0 ;;
            *) echo -e "${RED}Invalid option!${NC}"; sleep 1 ;;
        esac
    done
}

main_menu
