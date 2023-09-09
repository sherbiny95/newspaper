cd react-app/newspaper
npm clean-install
npm run build

aws s3 sync build s3://newspaper-app-034421805275

rm -r build

cd ../..