# The location of Ren-C
# See https://github.com/metaeducation/ren-c
RENC=../../../../../ren-c

printf "\nBuilding Ren-C ...\n"

# Build the executable
$RENC/prebuilt/r3-linux-x64-8994d23 $RENC/make.r

# Clean up the build output
rm -Rf objs
rm -Rf prep

printf "\nDone\n"