# Copyright (c) 2021-2022, ARM Limited and Contributors. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# Redistributions of source code must retain the above copyright notice, this
# list of conditions and the following disclaimer.
#
# Redistributions in binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation
# and/or other materials provided with the distribution.
#
# Neither the name of ARM nor the names of its contributors may be used
# to endorse or promote products derived from this software without specific
# prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

echo -off
for %i in 0 1 2 3 4 5 6 7 8 9 A B C D E F then
    if exist FS%i:\acs_results then
        FS%i:
        cd FS%i:\acs_results
        if not exist uefi then
            mkdir uefi
        endif
        cd uefi
        for %j in 0 1 2 3 4 5 6 7 8 9 A B C D E F then
            if exist FS%j:\EFI\BOOT\bsa\Bsa.efi then
                #BSA_VERSION_PRINT_PLACEHOLDER
                if exist FS%j:\EFI\BOOT\bsa\ir_bsa.flag then
                    #Executing for BSA IR. Execute only OS tests
                    FS%j:\EFI\BOOT\bsa\Bsa.efi -os -skip 900 -dtb BsaDevTree.dtb -f BsaResults.log
                    goto Done
                endif
                FS%j:\EFI\BOOT\bsa\Bsa.efi -skip 900 -f BsaResults.log
                goto Done
            endif
            if exist FS%j:\EFI\BOOT\bsa\sbsa\Sbsa.efi then
                if exist FS%i:\acs_results\uefi\SbsaResults.log then
		    echo "SBSA ACS is already run"
		    goto Done
		endif
	        FS%j:\EFI\BOOT\bsa\sbsa\Sbsa.efi -skip 800 -f SbsaResults.log
                reset
		goto Done
            endif
        endfor
        echo "Bsa.efi not found"
    endif
endfor
echo "BsaResults not found"
:Done
