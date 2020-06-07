# https://help.github.com/en/github/using-git/splitting-a-subfolder-out-into-a-new-repository

git clone git@github.com:mc-hitech/openos.git .
git clone git@github.com:MightyPirates/OpenComputers.git .
git remote add up --no-tags -t master-MC1.12 -t master-MC1.7.10 -f git@github.com:MightyPirates/OpenComputers.git
git checkout up/master-MC1.12 -b mc-1.12
git filter-branch --prune-empty --subdirectory-filter src/main/resources/assets/opencomputers/loot/openos mc-1.12
git push origin mc-1.12
# git submodule add -b mc-1.12 git@github.com:mc-hitech/openos.git  resources/openos

git clone git@github.com:mc-hitech/openos-components.git .
git remote add up --no-tags -t master -f git@github.com:VladislavSumin/OpenComputersWorld.git
git checkout up/master -b mc-1.12
git filter-branch --prune-empty --subdirectory-filter components mc-1.12
git push origin mc-1.12
# git submodule add -b mc-1.12 git@github.com:mc-hitech/openos-components.git  resources/components