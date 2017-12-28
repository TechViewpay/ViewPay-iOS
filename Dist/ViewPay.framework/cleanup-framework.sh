#!/bin/sh

#  cleanup-framework.sh
#  ViewPay
#
#  Created by Thibaut LE LEVIER on 01/12/2017.
#  Copyright © 2017 ViewPay. All rights reserved.

# use this build variables
# $BUILT_PRODUCTS_DIR
# $FRAMEWORKS_FOLDER_PATH
# $VALID_ARCHS

EXEC="${BUILT_PRODUCTS_DIR}/${FRAMEWORKS_FOLDER_PATH}/ViewPay.framework/ViewPay"

archs="$(lipo -info "${EXEC}" | rev | cut -d ':' -f1 | rev)"
stripped=""
for arch in $archs; do
    if ! [[ "${VALID_ARCHS}" == *"$arch"* ]]; then
        lipo -remove "$arch" -output "${EXEC}" "${EXEC}" || exit 1
        stripped="$stripped $arch"
    fi
done

echo "Architecture(s) ${stripped} have been removed from binary."
