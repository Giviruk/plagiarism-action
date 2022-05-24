import sys
import os

from github import Github
from git import Repo
from git import Git


ACCESS_TOKEN = sys.argv[1]
REPOSITORY_NAME = sys.argv[2]

# GitHub client
github_client = Github(ACCESS_TOKEN)

# Project repository
repo = github_client.get_repo(REPOSITORY_NAME)


def download_pulls():
    """
    Downloads pull requests in solutions folder. After execution all
    solutions will contain only .cs files
    """
    pulls = repo.get_pulls(state='open', sort='created')

    for pr in pulls:
        branch = pr.head.ref
        directory = f"./solutions/{pr.user.login}"
        login = "giviruk"
        password = "Trustme1*"
        remote = f"https://{login}:{password}@github.com/{REPOSITORY_NAME}.git"
        Repo.clone_from(remote, directory, branch=branch)


if __name__ == '__main__':
    download_pulls()
