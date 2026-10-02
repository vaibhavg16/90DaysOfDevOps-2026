#!/bin/bash
# gh-issue-simple.sh - Simple GitHub CLI automation

# Create a new issue
create_issue() {
    gh issue create \
        --title "$1" \
        --body "$2" \
        --label "$3"
}

# List open issues
list_issues() {
    gh issue list --state open --limit 10
}

# Close an issue
close_issue() {
    gh issue close "$1"
}

# Add comment to issue
add_comment() {
    gh issue comment "$1" --body "$2"
}

# Show usage
if [[ "$1" == "" ]] || [[ "$1" == "help" ]]; then
    echo "Usage:"
    echo "  ./gh-issue-simple.sh create \"title\" \"body\" \"labels\""
    echo "  ./gh-issue-simple.sh list"
    echo "  ./gh-issue-simple.sh close <number>"
    echo "  ./gh-issue-simple.sh comment <number> \"text\""
    exit 0
fi

# Run the command
case "$1" in
    create)
        create_issue "$2" "$3" "$4"
        ;;
    list)
        list_issues
        ;;
    close)
        close_issue "$2"
        ;;
    comment)
        add_comment "$2" "$3"
        ;;
    *)
        echo "Unknown command: $1"
        echo "Run with 'help' to see usage"
        ;;
esac
