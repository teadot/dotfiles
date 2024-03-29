sudo -v


echo '/==============================================================================\'
echo '||                                                                            ||'
echo '||    ____            _                                   _       _           ||'
echo '||   / ___| _   _ ___| |_ ___ _ __ ___    _   _ _ __   __| | __ _| |_ ___     ||'
echo '||   \___ \| | | / __| __/ _ \ '\''_ ` _ \  | | | | '\''_ \ / _` |/ _` | __/ _ \    ||'
echo '||    ___) | |_| \__ \ ||  __/ | | | | | | |_| | |_) | (_| | (_| | ||  __/    ||'
echo '||   |____/ \__, |___/\__\___|_| |_| |_|  \__,_| .__/ \__,_|\__,_|\__\___|    ||'
echo '||          |___/                              |_|                            ||'
echo '||                                                                            ||'
echo '\==============================================================================/'
echo \\n
echo "-> Update via apt"
# update ubuntu
sudo apt update -qq && sudo apt upgrade -qq --yes
echo \\n
echo "-> Update via brew"
# update brew
export HOMEBREW_NO_ENV_HINTS
brew update -q && brew upgrade -q
