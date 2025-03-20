#!/bin/sh
#
# Created by constructor 3.11.1
#
# NAME:  Miniconda3
# VER:   py312_25.1.1-2
# PLAT:  osx-arm64
# MD5:   bcaf076e244cdfee82376a3e77aa0a6a

set -eu
unset DYLD_LIBRARY_PATH DYLD_FALLBACK_LIBRARY_PATH

if ! echo "$0" | grep '\.sh$' > /dev/null; then
    printf 'Please run using "bash"/"dash"/"sh"/"zsh", but not "." or "source".\n' >&2
    exit 1
fi

# Export variables to make installer metadata available to pre/post install scripts
# NOTE: If more vars are added, make sure to update the examples/scripts tests too
export INSTALLER_NAME='Miniconda3'
export INSTALLER_VER='py312_25.1.1-2'
export INSTALLER_PLAT='osx-arm64'
export INSTALLER_TYPE="SH"

THIS_DIR=$(DIRNAME=$(dirname "$0"); cd "$DIRNAME"; pwd)
THIS_FILE=$(basename "$0")
THIS_PATH="$THIS_DIR/$THIS_FILE"
PREFIX="${HOME:-/opt}/miniconda3"
BATCH=0
FORCE=0
KEEP_PKGS=1
SKIP_SCRIPTS=0
SKIP_SHORTCUTS=0
TEST=0
REINSTALL=0
USAGE="
usage: $0 [options]

Installs ${INSTALLER_NAME} ${INSTALLER_VER}
-b           run install in batch mode (without manual intervention),
             it is expected the license terms (if any) are agreed upon
-f           no error if install prefix already exists
-h           print this help message and exit
-p PREFIX    install prefix, defaults to $PREFIX, must not contain spaces.
-s           skip running pre/post-link/install scripts
-m           disable the creation of menu items / shortcuts
-u           update an existing installation
-t           run package tests after installation (may install conda-build)
"

# We used to have a getopt version here, falling back to getopts if needed
# However getopt is not standardized and the version on Mac has different
# behaviour. getopts is good enough for what we need :)
# More info: https://unix.stackexchange.com/questions/62950/
while getopts "bifhkp:smut" x; do
    case "$x" in
        h)
            printf "%s\\n" "$USAGE"
            exit 2
        ;;
        b)
            BATCH=1
            ;;
        i)
            BATCH=0
            ;;
        f)
            FORCE=1
            ;;
        k)
            KEEP_PKGS=1
            ;;
        p)
            PREFIX="$OPTARG"
            ;;
        s)
            SKIP_SCRIPTS=1
            ;;
        m)
            SKIP_SHORTCUTS=1
            ;;
        u)
            FORCE=1
            ;;
        t)
            TEST=1
            ;;
        ?)
            printf "ERROR: did not recognize option '%s', please try -h\\n" "$x"
            exit 1
            ;;
    esac
done

# For pre- and post-install scripts
export INSTALLER_UNATTENDED="$BATCH"

# For testing, keep the package cache around longer
CLEAR_AFTER_TEST=0
if [ "$TEST" = "1" ] && [ "$KEEP_PKGS" = "0" ]; then
    CLEAR_AFTER_TEST=1
    KEEP_PKGS=1
fi

if [ "$BATCH" = "0" ] # interactive mode
then
    if [ "$(uname)" != "Darwin" ]; then
        printf "WARNING:\\n"
        printf "    Your operating system does not appear to be macOS, \\n"
        printf "    but you are trying to install a macOS version of %s.\\n" "${INSTALLER_NAME}"
        printf "    Are sure you want to continue the installation? [yes|no]\\n"
        printf "[no] >>> "
        read -r ans
        ans=$(echo "${ans}" | tr '[:lower:]' '[:upper:]')
        if [ "$ans" != "YES" ] && [ "$ans" != "Y" ]
        then
            printf "Aborting installation\\n"
            exit 2
        fi
    fi

    printf "\\n"
    printf "Welcome to %s %s\\n" "${INSTALLER_NAME}" "${INSTALLER_VER}"
    printf "\\n"
    printf "In order to continue the installation process, please review the license\\n"
    printf "agreement.\\n"
    printf "Please, press ENTER to continue\\n"
    printf ">>> "
    read -r dummy
    pager="cat"
    if command -v "more" > /dev/null 2>&1; then
      pager="more"
    fi
    "$pager" <<'EOF'
ANACONDA TERMS OF SERVICE

Please read these Terms of Service carefully before purchasing, using, accessing, or downloading any Anaconda Offerings (the "Offerings"). These Anaconda Terms of Service ("TOS") are between Anaconda, Inc. ("Anaconda") and you ("You"), the individual or entity acquiring and/or providing access to the Offerings. These TOS govern Your access, download, installation, or use of the Anaconda Offerings, which are provided to You in combination with the terms set forth in the applicable Offering Description, and are hereby incorporated into these TOS. Except where indicated otherwise, references to "You" shall include Your Users. You hereby acknowledge that these TOS are binding, and You affirm and signify your consent to these TOS by registering to, using, installing, downloading, or accessing the Anaconda Offerings effective as of the date of first registration, use, install, download or access, as applicable (the "Effective Date"). Capitalized definitions not otherwise defined herein are set forth in Section 15 (Definitions). If You do not agree to these Terms of Service, You must not register, use, install, download, or access the Anaconda Offerings.

1. ACCESS & USE
1.1 General License Grant. Subject to compliance with these TOS and any applicable Offering Description, Anaconda grants You a personal, non-exclusive, non-transferable, non-sublicensable, revocable, limited right to use the applicable Anaconda Offering strictly as detailed herein and as set forth in a relevant Offering Description. If You purchase a subscription to an Offering as set forth in a relevant Order, then the license grant(s) applicable to your access, download, installation, or use of a specific Anaconda Offering will be set forth in the relevant Offering Description and any definitive agreement which may be executed by you in writing or electronic in connection with your Order ("Custom Agreement"). License grants for specific Anaconda Offerings are set forth in the relevant Offering Description, if applicable.
1.2 License Restrictions. Unless expressly agreed by Anaconda, You may not:  (a) Make, sell, resell, license, sublicense, distribute, rent, or lease any Offerings available to anyone other than You or Your Users, unless expressly stated otherwise in an Order, Custom Agreement or the Documentation or as otherwise expressly permitted in writing by Anaconda; (b) Use the Offerings to store or transmit infringing, libelous, or otherwise unlawful or tortious material, or to store or transmit material in violation of third-party privacy rights; (c) Use the Offerings or Third Party Services to store or transmit Malicious Code, or attempt to gain unauthorized access to any Offerings or Third Party Services or their related systems or networks; (d)Interfere with or disrupt the integrity or performance of any Offerings or Third Party Services, or third-party data contained therein; (e) Permit direct or indirect access to or use of any Offerings or Third Party Services in a way that circumvents a contractual usage limit, or use any Offerings to access, copy or use any Anaconda intellectual property except as permitted under these TOS, a Custom Agreement, an Order or the Documentation; (f) Modify, copy or create derivative works of the Offerings or any part, feature, function or user interface thereof except, and then solely to the extent that, such activity is required to be permitted under applicable law; (g) Copy Content except as permitted herein or in an Order, a Custom Agreement or the Documentation or republish any material portion of any Offering in a manner competitive with the offering by Anaconda, including republication on another website or redistribute or embed any or all Offerings in a commercial product for redistribution or resale; (h) Frame or Mirror any part of any Content or Offerings, except if and to the extent permitted in an applicable Custom Agreement or Order for your own Internal Use and as permitted in a Custom Agreement or Documentation; (i) Except and then solely to the extent required to be permitted by applicable law, copy, disassemble, reverse engineer, or decompile an Offering, or access an Offering to build a competitive  service by copying or using similar ideas, features, functions or graphics of the Offering. You may not use any "deep-link", "page-scrape", "robot", "spider" or other automatic device, program, algorithm or methodology, or any similar or equivalent manual process, to access, acquire, copy or monitor any portion of our Offerings or Content. Anaconda reserves the right to end any such activity. If You would like to redistribute or embed any Offering in any product You are developing, please contact the Anaconda team for a third party redistribution commercial license.

2. USERS & LICENSING
2.1 Organizational Use.  Your registration, download, use, installation, access, or enjoyment of all Anaconda Offerings on behalf of an organization that has two hundred (200) or more employees or contractors ("Organizational Use") requires a paid license of Anaconda Business or Anaconda Enterprise. For sake of clarity, use by government entities and nonprofit entities with over 200 employees or contractors is considered Organizational Use.  Purchasing Starter tier license(s) does not satisfy the Organizational Use paid license requirement set forth in this Section 2.1.
 Educational Entities will be exempt from the paid license requirement, provided that the use of the Anaconda Offering(s) is solely limited to being used for a curriculum-based course. Anaconda reserves the right to monitor the registration, download, use, installation, access, or enjoyment of the Anaconda Offerings to ensure it is part of a curriculum.
2.2 Use by Authorized Users. Your "Authorized Users" are your employees, agents, and independent contractors (including outsourcing service providers) who you authorize to use the Anaconda Offering(s) on Your behalf for Your Internal Use, provided that You are responsible for: (a) ensuring that such Authorized Users comply with these TOS or an applicable Custom Agreement; and  (b) any breach of these TOS by such Authorized Users.
2.3 Use by Your Affiliates. Your Affiliates may use the Anaconda Offering(s) on Your behalf for Your Internal Use only with prior written approval from Anaconda. Such Affiliate usage is limited to those Affiliates who were defined as such upon the Effective Date of these TOS. Usage by organizations who become Your Affiliates after the Effective Date may require a separate license, at Anaconda's discretion.
2.4 Licenses for Systems. For each End User Computing Device ("EUCD") (i.e. laptops, desktop devices) one license covers one installation and a reasonable number of virtual installations on the EUCD (e.g. Docker, VirtualBox, Parallels, etc.). Any other installations, usage, deployments, or access must have an individual license per each additional usage.
2.5 Mirroring. You may only Mirror the Anaconda Offerings with the purchase of a Site License unless explicitly included in an Order Form or Custom Agreement.
2.6 Beta Offerings. Anaconda provides Beta Offerings "AS-IS" without support or any express or implied warranty or indemnity for any problems or issue s, and Anaconda has no liability relating to Your use of the Beta Offerings. Unless agreed in writing by Anaconda, You will not put Beta Offerings into production use. You may only use the Beta Offerings for the period specified by Anaconda in writing; (b) Anaconda, in its discretion, may stop providing the Beta Offerings at any time, at which point You must immediately cease using the Beta Offering(s); and (c) Beta Offerings may contain bugs, errors, or other issues..
2.7 Content. In consideration of Your payment of Subscription Fees, Anaconda hereby grants to You and Your Users a personal, non-exclusive, non-transferable, non-sublicensable, revocable, limited right and license during the Usage Term to access, input, use, transmit, copy, process, and measure the Content solely (1) within the Offerings and to the extent required to enable the ordinary and unmodified functionality of the Offerings as described in the Offering descriptions, and (2) for your Internal Use. Customer hereby acknowledge that the grant hereunder is solely being provided for your Internal Use and not to modify or to create any derivatives based on the Content.

3. ANACONDA OFFERINGS
3.1 Upgrades or Additional Copies of Offerings. You may only use additional copies of the Offerings beyond Your Order if You have acquired such rights under an agreement with Anaconda and you may only use Upgrades under Your Order to the extent you have discontinued use of prior versions of the Offerings.
3.2 Changes to Offerings; Maintenance. Anaconda may: (a) enhance or refine an Offering, although in doing so, Anaconda will not materially reduce the core functionality of that Offering, except as contemplated in Section 3.4 (End of Life); and (b) perform scheduled maintenance of the infrastructure and software used to provide an Offering, during which You may experience some disruption to that Offering.  Whenever reasonably practicable, Anaconda will provide You with advance notice of such maintenance. You acknowledge that occasionally, Anaconda may need to perform emergency maintenance without providing You advance notice, during which Anaconda may temporarily suspend Your access to, and use of, the Offering.
3.3 Use with Third Party Products. If You use the Anaconda Offering(s) with third party products, such use is at Your risk. Anaconda does not provide support or guarantee ongoing integration support for products that are not a native part of the Anaconda Offering(s).
3.4 End of Life. Anaconda reserves the right to discontinue the availability of an Anaconda Offering, including its component functionality, hereinafter referred to as "End of Life" or "EOL", by providing written notice through its official website, accessible at www.anaconda.com at least sixty (60) days prior to the EOL. In such instances, Anaconda is under no obligation to provide support in the transition away from the EOL Offering or feature, You shall transition to the latest version of the Anaconda Offering, as soon as the newest Version is released in order to maintain uninterrupted service. In the event that You or Your designated Anaconda Partner have previously remitted a prepaid fee for the utilization of Anaconda Offering, and if the said Offering becomes subject to End of Life (EOL) before the end of an existing Usage Term, Anaconda shall undertake commercially reasonable efforts to provide the necessary information to facilitate a smooth transition to an alternative Anaconda Offering that bears substantial similarity in terms of functionality and capabilities. Anaconda will not be held liable for any direct or indirect consequences arising from the EOL of an Offering or feature, including but not limited to data loss, service interruption, or any impact on business operations.

4. OPEN SOURCE, CONTENT & APPLICATIONS
4.1 Open-Source Software & Packages. Our Offerings include open-source libraries, components, utilities, and third-party software that is distributed or otherwise made available as "free software," "open-source software," or under a similar licensing or distribution model ("Open-Source Software"), which may be subject to third party open-source license terms (the "Open-Source Terms"). Certain Offerings are intended for use with open-source Python and R software packages and tools for statistical computing and graphical analysis ("Packages"), which are made available in source code form by third parties and Community Users. As such, certain Offerings interoperate with certain Open-Source Software components, including without limitation Open Source Packages, as part of its basic functionality; and to use certain Offerings, You will need to separately license Open-Source Software and Packages from the licensor. Anaconda is not responsible for Open-Source Software or Packages and does not assume any obligations or liability with respect to You or Your Users' use of Open-Source Software or Packages. Notwithstanding anything to the contrary, Anaconda makes no warranty or indemnity hereunder with respect to any Open-Source Software or Packages. Some of such Open-Source Terms or other license agreements applicable to Packages determine that to the extent applicable to the respective Open-Source Software or Packages licensed thereunder.  Any such terms prevail over any conflicting license terms, including these TOS. Anaconda will use best efforts to use only Open-Source Software and Packages that do not impose any obligation or affect the Customer Data (as defined hereinafter) or Intellectual Property Rights of Customer (beyond what is stated in the Open-Source Terms and herein), on an ordinary use of our Offerings that do not involve any modification, distribution, or independent use of such Open-Source Software.
4.2 Open Source Project Affiliation. Anaconda's software packages are not affiliated with upstream open source projects. While Anaconda may distribute and adapt open source software packages for user convenience, such distribution does not imply any endorsement, approval, or validation of the original software's quality, security, or suitability for specific purposes.
4.3 Third-Party Services and Content. You may access or use, at Your sole discretion, certain third-party products, services, and Content that interoperate with the Offerings including, but not limited to: (a) third party Packages, components, applications, services, data, content, or resources found in the Offerings, and (b) third-party service integrations made available through the Offerings or APIs (collectively, "Third-Party Services"). Each Third-Party Service is governed by the applicable terms and policies of the third-party provider. The terms under which You access, use, or download Third-Party Services are solely between You and the applicable Third-Party Service provider. Anaconda does not make any representations, warranties, or guarantees regarding the Third-Party Services or the providers thereof, including, but not limited to, the Third-Party Services' continued availability, security, and integrity. Third-Party Services are made available by Anaconda on an "AS IS" and "AS AVAILABLE" basis, and Anaconda may cease providing them in the Offerings at any time in its sole discretion and You shall not be entitled to any refund, credit, or other compensation.

5. CUSTOMER CONTENT, APPLICATIONS & RESPONSIBILITIES
5.1 Customer Content and Applications. Your content remains your own. We assume no liability for the content you publish through our services. However, you must adhere to our Acceptable Use Policy while utilizing our platform. You can share your submitted Customer Content or Customer Applications with others using our Offerings. By sharing Your Content, you grant legal rights to those You give access to. Anaconda has no responsibility to enforce, police, or otherwise aid You in enforcing or policing the terms of the license(s) or permission(s) You have chosen to offer. Anaconda is not liable for third-party misuse of your submitted Customer Content or Customer Applications on our Offerings. Customer Applications does not include any derivative works that might be created out of open source where the license prohibits derivative works.
5.2 Removal of Customer Content and Applications. If You received a removal notification regarding any Customer Content or a Customer Application due to legal reasons or policy violations, you promptly must do so. If You don't comply or the violation persists, Anaconda may disable the Content or your access to the Content. If required, You must confirm in writing that you've deleted or stopped using the Customer Content or Customer Applications. Anaconda might also remove Customer Content or Customer Applications if requested by a Third-party rights holder whose rights have been violated. Anaconda isn't obliged to store or provide copies of Customer Content or Customer Applications that have been removed, is Your responsibility to maintain a back-up of Your Content.
5.3 Protecting Account Access. You will keep all account information up to date, use reasonable means to protect Your account information, passwords, and other login credentials, and promptly notify Anaconda of any known or suspected unauthorized use of or access to Your account.

6. YOUR DATA, PRIVACY & SECURITY
6.1 Your Data. Your Data, hereinafter "Customer Data", is any data, files, attachments, text, images, reports, personal information, or any other data that is, uploaded or submitted, transmitted, or otherwise made available, to or through the Offerings, by You or any of your Authorized Users and is processed by Anaconda on your behalf. For the avoidance of doubt, Anonymized Data is not regarded as Customer Data. You retain all right, title, interest, and control, in and to the Customer Data, in the form submitted to the Offerings. Subject to these TOS, You grant Anaconda a worldwide, royalty-free, non-exclusive license to store, access, use, process, copy, transmit, distribute, perform, export, and display the Customer Data, and solely to the extent that reformatting Customer Data for display in the Offerings constitutes a modification or derivative work, the foregoing license also includes the right to make modifications and derivative works. The aforementioned license is hereby granted solely: (i) to maintain, improve and provide You the Offerings; (ii) to prevent or address technical or security issues and resolve support requests; (iii) to investigate when we have a good faith belief, or have received a complaint alleging, that such Customer Data is in violation of these TOS; (iv) to comply with a valid legal subpoena, request, or other lawful process; (v) detect and avoid overage of use of our Offering and confirm compliance by Customer with these TOS and other applicable agreements and policies;  (vi) to create Anonymized Data whether directly or through telemetry, and (vi) as expressly permitted in writing by You. Anaconda may use and retain your Account Information for business purposes related to these TOS and to the extent necessary to meet Anaconda's legal compliance obligations (including, for audit and anti-fraud purposes). We reserve the right to utilize aggregated data to enhance our Offerings functionality, ensure  compliance, avoid Offering overuse, and derive insights from customer behavior, in strict adherence to our Privacy Policy.
6.2 Processing Customer Data. The ordinary operation of certain Offerings requires Customer Data to pass through Anaconda's network. To the extent that Anaconda processes Customer Data on your behalf that includes Personal Data, Anaconda will handle such Personal Data in compliance with our Data Processing Addendum.
6.3 Privacy Policy.  If You obtained the Offering under these TOS, the conditions pertaining to the handling of your Personal Data, as described in our Privacy Policy, shall govern. However, in instances where your offering acquisition is executed through a Custom Agreement, the terms articulated within our Data Processing Agreement ("DPA") shall take precedence over our Privacy Policy concerning data processing matters.
6.4 Aggregated  Data. Anaconda retains all right, title, and interest in the models, observations, reports, analyses, statistics, databases, and other information created, compiled, analyzed, generated or derived by Anaconda from platform, network, or traffic data in the course of providing the Offerings ("Aggregated Data"). To the extent the Aggregated Data includes any Personal Data, Anaconda will handle such Personal Data in compliance with applicable data protection laws and the Privacy Policy or DPA, as applicable.
6.5 Offering Security. Anaconda will implement industry standard security safeguards for the protection of Customer Confidential Information, including any Customer Content originating or transmitted from or processed by the Offerings and/or cached on or within Anaconda's network and stored within the Offerings in accordance with its policies and procedures. These safeguards include commercially reasonable administrative, technical, and organizational measures to protect Customer Content against destruction, loss, alteration, unauthorized disclosure, or unauthorized access, including such things as information security policies and procedures, security awareness training, threat and vulnerability management, incident response and breach notification, and vendor risk management procedures.

7. SUPPORT
7.1 Support Services. Anaconda offers Support Services that may be included with an Offering. Anaconda will provide the purchased level of Support Services in accordance with the terms of the Support Policy as detailed in the applicable Order. Unless ordered, Anaconda shall have no responsibility to deliver Support Services to You. The Support Service Levels and Tiers are described in the relevant Support Policy, found here.
7.2 Information Backups. You are aware of the risk that Your Content may be lost or irreparably damaged due to faults, suspension, or termination. While we might back up data, we cannot guarantee these backups will occur to meet your frequency needs or ensure successful recovery of Your Content. It is your obligation to back up any Content you wish to preserve. We bear no legal liability for the loss or damage of Your Content.

8. OWNERSHIP & INTELLECTUAL PROPERTY
8.1 General. Unless agreed in writing, nothing in these TOS transfers ownership in, or grants any license to, any Intellectual Property Rights.
8.2 Feedback. Anaconda may use any feedback You provide in connection with Your use of the Anaconda Offering(s) as part of its business operations. You hereby agree that any feedback provided to Anaconda will be the intellectual property of Anaconda without compensation to the provider, author, creator, or inventor of providing the feedback.
8.3 DMCA Compliance. You agree to adhere to our Digital Millennium Copyright Act (DMCA) policies established in our Acceptable Use Policy.

9. CONFIDENTIAL INFORMATION
9.1 Confidential Information. In connection with these TOS and the Offerings (including the evaluation thereof), each Party ("Discloser") may disclose to the other Party ("Recipient"), non-public business, product, technology and marketing information, including without limitation, customers lists and information, know-how, software and any other non-public information that is either identified as such or should reasonably be understood to be confidential given the nature of the information and the circumstances of disclosure, whether disclosed prior or after the Effective Date ("Confidential Information"). For the avoidance of doubt, (i) Customer Data is regarded as your Confidential Information, and (ii) our Offerings, including Beta Offerings, and inclusive of their underlying technology, and their respective performance information, as well as any data, reports, and materials we provided to You in connection with your evaluation or use of the Offerings, are regarded as our Confidential Information. Confidential Information does not include information that (a) is or becomes generally available to the public without breach of any obligation owed to the Discloser; (b) was known to the Recipient prior to its disclosure by the Discloser without breach of any obligation owed to the Discloser; (c) is received from a third party without breach of any obligation owed to the Discloser; or (d) was independently developed by the Recipient without any use or reference to the Confidential Information.
9.2 Confidentiality Obligations. The Recipient will (i) take at least reasonable measures to prevent the unauthorized disclosure or use of Confidential Information, and limit access to those employees, affiliates, service providers and agents, on a need to know basis and who are bound by confidentiality obligations at least as restrictive as those contained herein; and (ii) not use or disclose any Confidential Information to any third party, except as part of its performance under these TOS and to consultants and advisors to such party, provided that any such disclosure shall be governed by confidentiality obligations at least as restrictive as those contained herein.
9.3 Compelled Disclosure. Notwithstanding the above, Confidential Information may be disclosed pursuant to the order or requirement of a court, administrative agency, or other governmental body; provided, however, that to the extent legally permissible, the Recipient shall make best efforts to provide prompt written notice of such court order or requirement to the Discloser to enable the Discloser to seek a protective order or otherwise prevent or restrict such disclosure.

10. INDEMNIFICATION
10.1 By Customer. Customer hereby agree to indemnify, defend and hold harmless Anaconda and our Affiliates and their respective officers, directors, employees and agents from and against any and all claims, damages, obligations, liabilities, losses, reasonable expenses or costs incurred as a result of any third party claim arising from (i) You and/or any of your Authorized Users', violation of these TOS or applicable law; and/or (ii) Customer Data and/or Customer Content, including the use of Customer Data and/or Customer Content by Anaconda and/or any of our subcontractors, which infringes or violates, any third party's rights, including, without limitation, Intellectual Property Rights.
10.2 By Anaconda. Anaconda will defend any third party claim against You that Your valid use of Anaconda Offering(s) under Your Order infringes a third party's U.S. patent, copyright or U.S. registered trademark (the "IP Claim"). Anaconda will indemnify You against the final judgment entered by a court of competent jurisdiction or any settlements arising out of an IP Claim, provided that You:  (a) promptly notify Anaconda in writing of the IP Claim;  (b) fully cooperate with Anaconda in the defense of the IP Claim; and (c) grant Anaconda the right to exclusively control the defense and settlement of the IP Claim, and any subsequent appeal. Anaconda will have no obligation to reimburse You for Your attorney fees and costs in connection with any IP Claim for which Anaconda is providing defense and indemnification hereunder. You, at Your own expense, may retain Your own legal representation.
10.3 Additional Remedies. If an IP Claim is made and prevents Your exercise of the Usage Rights, Anaconda will either procure for You the right to continue using the Anaconda Offering(s), or replace or modify the Anaconda Offering(s) with functionality that is non-infringing. Only if Anaconda determines that these alternatives are not reasonably available, Anaconda may terminate Your Usage Rights granted under these TOS upon written notice to You and will refund You a prorated portion of the fee You paid for the Anaconda Offering(s) for the remainder of the unexpired Usage Term.
10.4 Exclusions.  Anaconda has no obligation regarding any IP Claim based on: (a) compliance with any designs, specifications, or requirements You provide or a third party provides; (b) Your modification of any Anaconda Offering(s) or modification by a third party; (c) the amount or duration of use made of the Anaconda Offering(s), revenue You earned, or services You offered; (d) combination, operation, or use of the Anaconda Offering(s) with non-Anaconda products, software or business processes; (e) Your failure to modify or replace the Anaconda Offering(s) as required by Anaconda; or (f) any Anaconda Offering(s) provided on a no charge, beta or evaluation basis; or (g) your use of the Open Source Software and/or Third Party Services made available to You within the Anaconda Offerings.
10.5 Exclusive Remedy. This Section 9 (Indemnification) states Anaconda's entire obligation and Your exclusive remedy regarding any IP Claim against You.

11. LIMITATION OF LIABILITY
11.1 Limitation of Liability. Neither Party will be liable for indirect, incidental, exemplary, punitive, special or consequential damages; loss or corruption of data or interruption or loss of business; or loss of revenues, profits, goodwill or anticipated sales or savings except as a result of violation of Anaconda's Intellectual Property Rights. Except as a result of violation of Anaconda's Intellectual Property Rights, the maximum aggregate liability of each party under these TOS is limited to: (a) for claims solely arising from software licensed on a perpetual basis, the fees received by Anaconda for that Offering; or (b) for all other claims, the fees received by Anaconda for the applicable Anaconda Offering and attributable to the 12 month period immediately preceding the first claim giving rise to such liability; provided if no fees have been received by Anaconda, the maximum aggregate liability shall be one hundred US dollars ($100). This limitation of liability applies whether the claims are in warranty, contract, tort (including negligence), infringement, or otherwise, even if either party has been advised of the possibility of such damages. Nothing in these TOS limits or excludes any liability that cannot be limited or excluded under applicable law. This limitation of liability is cumulative and not per incident.

12. FEES & PAYMENT
12.1 Fees. Orders for the Anaconda Offering(s) are non-cancellable. Fees for Your use of an Anaconda Offering are set out in Your Order or similar purchase terms with Your Approved Source. If payment is not received within the specified payment terms, any overdue and unpaid balances will be charged interest at a rate of five percent (5%) per month, charged daily until the balance is paid.
12.2 Billing. You agree to provide us with updated, accurate, and complete billing information, and You hereby authorize Anaconda, either directly or through our payment processing service or our Affiliates, to charge the applicable Fees set forth in Your Order via your selected payment method, upon the due date. Unless expressly set forth herein, the Fees are non-cancelable and non-refundable. We reserve the right to change the Fees at any time, upon notice to You if such change may affect your existing Subscriptions or other renewable services upon renewal. In the event of failure to collect the Fees You owe, we may, at our sole discretion (but shall not be obligated to), retry to collect at a later time, and/or suspend or cancel the Account, without notice. If You pay fees by credit card, Anaconda will charge the credit card in accordance with Your Subscription plan. You remain liable for any fees which are rejected by the card issuer or charged back to Anaconda.
12.3 Taxes. The Fees are exclusive of any and all taxes (including without limitation, value added tax, sales tax, use tax, excise, goods and services tax, etc.), levies, or duties, which may be imposed in respect of these TOS and the purchase or sale, of the Offerings or other services set forth in the Order (the "Taxes"), except for Taxes imposed on our income.
12.4 Payment Through Anaconda Partner. If You purchased an Offering from an Anaconda Partner or other Approved Source, then to the extent there is any conflict between these TOS and any terms of service entered between You and the respective Partner, including any purchase order, then, as between You and Anaconda, these TOS shall prevail. Any rights granted to You and/or any of the other Users in a separate agreement with a Partner which are not contained in these TOS, apply only in connection vis a vis the Partner.

13. TERM, TERMINATION & SUSPENSION
13.1 Subscription Term. The Offerings are provided on a subscription basis for the term specified in your Order (the "Subscription Term"). The termination or suspension of an individual Order will not terminate or suspend any other Order. If these TOS are terminated in whole, all outstanding Order(s) will terminate.
13.2 Subscription Auto-Renewal. To prevent interruption or loss of service when using the Offerings or any Subscription and Support Services will renew automatically, unless You cancel your license to the Offering, Subscription or Support Services agreement prior to their expiration.
13.3 Termination. If a party materially breaches these TOS and does not cure that breach within 30 days after receipt of written notice of the breach, the non-breaching party may terminate these TOS for cause.  Anaconda may immediately terminate your Usage Rights if You breach Section 1 (Access & Use), Section 4 (Open Source, Content & Applications), Section 8 (Ownership & Intellectual Property) or Section 16.10 (Export) or any of the Offering Descriptions.
13.4 Survival. Section 8 (Ownership & Intellectual Property), Section 6.4 (Aggregated Data), Section 9 (Confidential Information), Section 9.3 (Warranty Disclaimer), Section 12 (Limitation of Liability), Section 14 (Term, Termination & Suspension),  obligations to make payment under Section 13 which accrued prior to termination (Fees & Payment), Section 14.4 (Survival), Section 14.5 (Effect of Termination), Section 15 (Records, User Count) and Section 16 (General Provisions) survive termination or expiration of these TOS.
13.5 Effect of Termination. Upon termination of the TOS, You must stop using the Anaconda Offering(s) and destroy any copies of Anaconda Proprietary Technology and Confidential Information within Your control. Upon Anaconda's termination of these TOS for Your material breach, You will pay Anaconda or the Approved Source any unpaid fees through to the end of the then-current Usage Term. If You continue to use or access any Anaconda Offering(s) after termination, Anaconda or the Approved Source may invoice You, and You agree to pay, for such continued use. Anaconda may require evidence of compliance with this Section 13. Upon request, you agree to provide evidence of compliance to Anaconda demonstrating that all proprietary Anaconda Offering(s) or components thereof have been removed from your systems. Such evidence may be in the form of a system scan report or other similarly detailed method.
13.6 Excessive Usage. We shall have the right to throttle or restrict Your access to the Offerings where we, at our sole discretion, believe that You and/or any of your Authorized Users, have misused the Offerings or otherwise use the Offerings in an excessive manner compared to the anticipated standard use (at our sole discretion) of the Offerings, including, without limitation, excessive network traffic and bandwidth, size and/or length of Content, quality and/or format of Content, sources of Content, volume of download time, etc.

14. RECORDS, USER COUNT
14.1 Verification Records. During the Usage Term and for a period of thirty six (36) months after its expiry or termination, You will take reasonable steps to maintain complete and accurate records of Your use of the Anaconda Offering(s) sufficient to verify compliance with these TOS ("Verification Records"). Upon reasonable advance notice, and no more than once per 12 month period unless the prior review showed a breach by You, You will, within thirty (30) days from Anaconda's notice, allow Anaconda and/or its auditors access to the Verification Records and any applicable books, systems (including Anaconda product(s) or other equipment), and accounts during Your normal business hours.
14.2 Quarterly User Count. In accordance with the pricing structure stipulated within the relevant Order Form and this Agreement, in instances where the pricing assessment is contingent upon the number of users, Anaconda will conduct a periodic true-up on  a quarterly basis to ascertain the alignment between the actual number of users utilizing the services and the initially reported user count, and to assess for any unauthorized or noncompliant usage.
14.3 Penalties for Overage or Noncompliant Use.  Should the actual user count exceed the figure initially provided, or unauthorized usage is uncovered, the contracting party shall remunerate the difference to Anaconda, encompassing the additional users or noncompliant use in compliance with Anaconda's then-current pricing terms. The payment for such difference shall be due in accordance with the invoicing and payment provisions specified in these TOS and/or within the relevant Order and the Agreement. In the event there is no custom commercial agreement beyond these TOS between You and Anaconda at the time of a true-up pursuant to Section 13.2, and said true-up uncovers unauthorized or noncompliant usage, You will remunerate Anaconda via a back bill for any fees owed as a result of all unauthorized usage after April of 2020.  Fees may be waived by Anaconda at its discretion.

15. GENERAL PROVISIONS
15.1 Order of Precedence. If there is any conflict between these TOS and any Offering Description expressly referenced in these TOS, the order of precedence is: (a) such Offering Description;  (b) these TOS (excluding the Offering Description and any Anaconda policies); then (c) any applicable Anaconda policy expressly referenced in these TOS and any agreement expressly incorporated by reference.  If there is a Custom Agreement, the Custom Agreement shall control over these TOS.
15.2 Entire Agreement. These TOS are the complete agreement between the parties regarding the subject matter of these TOS and supersedes all prior or contemporaneous communications, understandings or agreements (whether written or oral) unless a Custom Agreement has been executed where, in such case, the Custom Agreement shall continue in full force and effect and shall control.
15.3 Modifications to the TOS. Anaconda may change these TOS or any of its components by updating these TOS on legal.anaconda.com/terms-of-service. Changes to the TOS apply to any Orders acquired or renewed after the date of modification.
15.4 Third Party Beneficiaries. These TOS do not grant any right or cause of action to any third party.
15.5 Assignment. Anaconda may assign this Agreement to (a) an Affiliate; or (b) a successor or acquirer pursuant to a merger or sale of all or substantially all of such party's assets at any time and without written notice. Subject to the foregoing, this Agreement will be binding upon and will inure to the benefit of Anaconda and their respective successors and permitted assigns.
15.6 US Government End Users. The Offerings and Documentation are deemed to be "commercial computer software" and "commercial computer software documentation" pursuant to FAR 12.212 and DFARS 227.7202. All US Government end users acquire the Offering(s) and Documentation with only those rights set forth in these TOS. Any provisions that are inconsistent with federal procurement regulations are not enforceable against the US Government. In no event shall source code be provided or considered to be a deliverable or a software deliverable under these TOS.
15.7 Anaconda Partner Transactions. If You purchase access to an Anaconda Offering from an Anaconda Partner, the terms of these TOS apply to Your use of that Anaconda Offering and prevail over any inconsistent provisions in Your agreement with the Anaconda Partner.
15.8 Children and Minors. If You are under 18 years old, then by entering into these TOS You explicitly stipulate that (i) You have legal capacity to consent to these TOS or Your parent or legal guardian has done so on Your behalf;  (ii) You understand the Anaconda Privacy Policy; and (iii) You understand that certain underage users are strictly prohibited from using certain features and functionalities provided by the Anaconda Offering(s). You may not enter into these TOS if You are under 13 years old.  Anaconda does not intentionally seek to collect or solicit personal information from individuals under the age of 13. In the event we become aware that we have inadvertently obtained personal information from a child under the age of 13 without appropriate parental consent, we shall expeditiously delete such information. If applicable law allows the utilization of an Offering with parental consent, such consent shall be demonstrated in accordance with the prescribed process outlined by Anaconda's Privacy Policy for obtaining parental approval.
15.9 Compliance with Laws.  Each party will comply with all laws and regulations applicable to their respective obligations under these TOS.
15.10 Export. The Anaconda Offerings are subject to U.S. and local export control and sanctions laws. You acknowledge and agree to the applicability of and Your compliance with those laws, and You will not receive, use, transfer, export or re-export any Anaconda Offerings in a way that would cause Anaconda to violate those laws. You also agree to obtain any required licenses or authorizations.  Without limiting the foregoing, You may not acquire Offerings if: (1) you are in, under the control of, or a national or resident of Cuba, Iran, North Korea, Sudan or Syria or if you are on the U.S. Treasury Department's Specially Designated Nationals List or the U.S. Commerce Department's Denied Persons List, Unverified List or Entity List or (2) you intend to supply the acquired goods, services or software to Cuba, Iran, North Korea, Sudan or Syria (or a national or resident of one of these countries) or to a person on the Specially Designated Nationals List, Denied Persons List, Unverified List or Entity List.
15.11 Governing Law and Venue. THESE TOS, AND ANY DISPUTES ARISING FROM THEM, WILL BE GOVERNED EXCLUSIVELY BY THE GOVERNING LAW OF DELAWARE AND WITHOUT REGARD TO CONFLICTS OF LAWS RULES OR THE UNITED NATIONS CONVENTION ON THE INTERNATIONAL SALE OF GOODS. EACH PARTY CONSENTS AND SUBMITS TO THE EXCLUSIVE JURISDICTION OF COURTS LOCATED WITHIN THE STATE OF DELAWARE.  EACH PARTY DOES HEREBY WAIVE HIS/HER/ITS RIGHT TO A TRIAL BY JURY, TO PARTICIPATE AS THE MEMBER OF A CLASS IN ANY PURPORTED CLASS ACTION OR OTHER PROCEEDING OR TO NAME UNNAMED MEMBERS IN ANY PURPORTED CLASS ACTION OR OTHER PROCEEDINGS. You acknowledge that any violation of the requirements under Section 4 (Ownership & Intellectual Property) or Section 7 (Confidential Information) may cause irreparable damage to Anaconda and that Anaconda will be entitled to seek injunctive and other equitable or legal relief to prevent or compensate for such unauthorized use.
15.12 California Residents. If you are a California resident, in accordance with Cal. Civ. Code subsection 1789.3, you may report complaints to the Complaint Assistance Unit of the Division of Consumer Services of the California Department of Consumer Affairs by contacting them in writing at 1625 North Market Blvd., Suite N 112, Sacramento, CA 95834, or by telephone at (800) 952-5210.
15.13 Notices. Any notice delivered by Anaconda to You under these TOS will be delivered via email, regular mail or postings on www.anaconda.com. Notices to Anaconda should be sent to Anaconda, Inc., Attn: Legal at 1108 Lavaca Street, Suite 110-645 Austin, TX 78701 and legal@anaconda.com.
15.14 Publicity. Anaconda reserves the right to reference You as a customer and display your logo and name on our website and other promotional materials for marketing purposes. Any display of your logo and name shall be in compliance with Your branding guidelines, if provided  by notice pursuant to Section 14.12 by You. Except as provided in this Section 14.13 or by separate mutual written agreement, neither party will use the logo, name or trademarks of the other party or refer to the other party in any form of publicity or press release without such party's prior written approval.
15.15 Force Majeure. Except for payment obligations, neither Party will be responsible for failure to perform its obligations due to an event or circumstances beyond its reasonable control.
15.16 No Waiver; Severability. Failure by either party to enforce any right under these TOS will not waive that right. If any portion of these TOS are not enforceable, it will not affect any other terms.
15.17 Electronic Signatures.  IF YOUR ACCEPTANCE OF THESE TERMS FURTHER EVIDENCED BY YOUR AFFIRMATIVE ASSENT TO THE SAME (E.G., BY A "CHECK THE BOX" ACKNOWLEDGMENT PROCEDURE), THEN THAT AFFIRMATIVE ASSENT IS THE EQUIVALENT OF YOUR ELECTRONIC SIGNATURE TO THESE TERMS.  HOWEVER, FOR THE AVOIDANCE OF DOUBT, YOUR ELECTRONIC SIGNATURE IS NOT REQUIRED TO EVIDENCE OR FACILITATE YOUR ACCEPTANCE AND AGREEMENT TO THESE TERMS, AS YOU AGREE THAT THE CONDUCT DESCRIBED IN THESE TOS AS RELATING TO YOUR ACCEPTANCE AND AGREEMENT TO THESE TERMS ALONE SUFFICES.

16. DEFINITIONS
"Affiliate" means any corporation or legal entity that directly or indirectly controls, or is controlled by, or is under common control with the relevant party, where "control" means to: (a) own more than 50% of the relevant party; or (b) be able to direct the affairs of the relevant party through any lawful means (e.g., a contract that allows control).
"Anaconda" "we" "our" or "us" means Anaconda, Inc. or its applicable Affiliate(s).
"Anaconda Content" means any:  Anaconda Content includes geographic and domain information, rules, signatures, threat intelligence and data feeds and Anaconda's compilation of suspicious URLs.
"Anaconda Partner" or "Partner" means an Anaconda authorized reseller, distributor or systems integrator authorized by Anaconda to sell Anaconda Offerings.
"Anaconda Offering" or "Offering" means the Anaconda Services, Anaconda software, Documentation, software development kits ("SDKs"), application programming interfaces ("APIs"), and any other items or services provided by Anaconda any Upgrades thereto under the terms of these TOS, the relevant Offering Descriptions, as identified in the relevant Order, and/or any updates thereto.
"Anaconda Proprietary Technology" means any software, code, tools, libraries, scripts, APIs, SDKs, templates, algorithms, data science recipes (including any source code for data science recipes and any modifications to such source code), data science workflows, user interfaces, links, proprietary methods and systems, know-how, trade secrets, techniques, designs, inventions, and other tangible or intangible technical material, information and works of authorship underlying or otherwise used to make available the Anaconda Offerings including, without limitation, all Intellectual Property Rights therein and thereto.
"Anaconda Service" means Support Services and any other consultation or professional services provided by or on behalf of Anaconda under the terms of the Agreement, as identified in the applicable Order and/or SOW.
"Approved Source" means Anaconda or an Anaconda Partner.
"Anonymized Data" means any Personal Data (including Customer Personal Data) and data regarding usage trends and behavior with respect to Offerings, that has been anonymized such that the Data Subject to whom it relates cannot be identified, directly or indirectly, by Anaconda or any other party reasonably likely to receive or access that anonymized Personal Data or usage trends and behavior.
"Authorized Users" means Your Users, Your Affiliates who have been identified to Anaconda and approved, Your third-party service providers, and each of their respective Users who are permitted to access and use the Anaconda Offering(s) on Your behalf as part of Your Order.
"Beta Offerings" Beta Offerings means any portion of the Offerings offered on a "beta" basis, as designated by Anaconda, including but not limited to, products, plans, services, and platforms.
"Content" means Packages, components, applications, services, data, content, or resources, which are available for download access or use through the Offerings, and owned by third-party providers, defined herein as Third Party Content, or Anaconda, defined herein as Anaconda Content.
"Documentation" means the technical specifications and usage materials officially published by Anaconda specifying the functionalities and capabilities of the applicable Anaconda Offerings.
"Educational Entities" means educational organizations, classroom learning environments, or academic instructional organizations.
"Fees" mean the costs and fees for the Anaconda Offerings(s) set forth within the Order and/or SOW, or any fees due immediately when purchasing via the web-portal.
"Government Entities" means any body, board, department, commission, court, tribunal, authority, agency or other instrumentality of any such government or otherwise exercising any executive, legislative, judicial, administrative or regulatory functions of any Federal, State, or local government (including multijurisdictional agencies, instrumentalities, and entities of such government)
"Internal Use" means Customer's use of an Offering for Customer's own internal operations, to perform Python/R data science and machine learning on a single platform from Customer's systems, networks, and devices. Such use does not include use on a service bureau basis or otherwise to provide services to, or process data for, any third party, or otherwise use to monitor or service the systems, networks, and devices of third parties.
"Intellectual Property Rights" means any and all now known or hereafter existing worldwide: (a) rights associated with works of authorship, including copyrights, mask work rights, and moral rights; (b) trademark or service mark rights; (c) Confidential Information, including trade secret rights; (d) patents, patent rights, and industrial property rights; (e) layout design rights, design rights, and other proprietary rights of every kind and nature other than trade dress, and similar rights; and (f) all registrations, applications, renewals, extensions, or reissues of the foregoing.
"Malicious Code" means code designed or intended to disable or impede the normal operation of, or provide unauthorized access to, networks, systems, Software or Cloud Services other than as intended by the Anaconda Offerings (for example, as part of some of Anaconda's Security Offering(s).
"Mirror" or "Mirroring" means the unauthorized or authorized act of duplicating, copying, or replicating an Anaconda Offering,  (e.g. repository, including its contents, files, and data),, from Anaconda's servers to another location. If Mirroring is not performed under a site license, or by written authorization by Anaconda, the Mirroring constitutes a violation of Anaconda's Terms of Service and licensing agreements.
"Offering Description"' means a legally structured and detailed description outlining the features, specifications, terms, and conditions associated with a particular product, service, or offering made available to customers or users. The Offering Description serves as a legally binding document that defines the scope of the offering, including pricing, licensing terms, usage restrictions, and any additional terms and conditions.
"Order" or "Order Form"  means a legally binding document, website page, or electronic mail that outlines the specific details of Your purchase of Anaconda Offerings or Anaconda Services, including but not limited to product specifications, pricing, quantities, and payment terms either issued by Anaconda or from an Approved Source.
"Personal Data" Refers to information falling within the definition of 'personal data' and/or 'personal information' as outlined by Relevant Data Protection Regulations, such as a personal identifier (e.g., name, last name, and email), financial information (e.g., bank account numbers) and online identifiers (e.g., IP addresses, geolocation.
"Relevant Data Protection Regulations" mean, as applicable, (a) Personal Information Protection and Electronic Documents Act (S.C. 2000, c. 5) along with any supplementary or replacement bills enacted into law by the Government of Canada (collectively "PIPEDA"); (b) the General Data Protection Regulation (Regulation (EU) 2016/679) and applicable laws by EU member states which either supplement or are necessary to implement the GDPR (collectively "GDPR"); (c) the California Consumer Privacy Act of 2018 (Cal. Civ. Code subsection 1798.198(a)), along with its various amendments (collectively "CCPA"); (d) the GDPR as applicable under section 3 of the European Union (Withdrawal) Act 2018 and as amended by the Data Protection, Privacy and Electronic Communications (Amendments etc.) (EU Exit) Regulations 2019 (as amended) (collectively "UK GDPR"); (e) the Swiss Federal Act on Data Protection  of June 19, 1992 and as it may be revised from time to time (the "FADP"); and (f) any other applicable law related to the protection of Personal Data.
"Site License'' means a License that confers Customer the right to use Anaconda Offerings throughout an organization, encompassing authorized Users without requiring individual licensing arrangements. Site Licenses have limits based on company size as set forth in a relevant Order, and do not cover future assignment of Users through mergers and acquisitions unless otherwise specified in writing by Anaconda.
"Software" means the Anaconda Offerings, including Upgrades, firmware, and applicable Documentation.
"Subscription" means the payment of recurring Fees for accessing and using Anaconda's Software and/or an Anaconda Service over a specified period. Your subscription grants you the right to utilize our products, receive updates, and access support, all in accordance with our terms and conditions for such Offering.
"Subscription Fees" means the costs and Fees associated with a Subscription.
"Support Services" means the support and maintenance services provided by Anaconda to You in accordance with the relevant support and maintenance policy ("Support Policy") located at legal.anaconda.com/support-policy.
"Third Party Services" means external products, applications, or services provided by entities other than Anaconda. These services may be integrated with or used in conjunction with Anaconda's offerings but are not directly provided or controlled by Anaconda.
"Upgrades" means all updates, upgrades, bug fixes, error corrections, enhancements and other modifications to the Software.
"Usage Term" means the period commencing on the date of delivery and continuing until expiration or termination of the Order, during which period You have the right to use the applicable Anaconda Offering.
"User"  means the individual, system (e.g. virtual machine, automated system, server-side container, etc.) or organization that (a) has visited, downloaded or used the Offerings(s), (b) is using the Offering or any part of the Offerings(s), or (c) directs the use of the Offerings(s) in the performance of its functions.
"Version" means the Offering configuration identified by a numeric representation, whether left or right of the decimal place.


OFFERING DESCRIPTION: MINICONDA


This Offering Description describes the Anaconda Premium Repository (hereinafter the "Premium Repository"). Your use of the Premium Repository is governed by this Offering Description, and the Anaconda Terms of Service (the "TOS", available at www.anaconda.com/legal), collectively the "Agreement" between you ("You") and Anaconda, Inc. ("We" or "Anaconda"). In the event of a conflict, the order of precedence is as follows: 1) this Offering Description; 2) if applicable, a Custom Agreement; and 3) the TOS if no Custom Agreement is in place. Capitalized terms used in this Offering Description and/or the Order not otherwise defined herein, including in Section 6 (Definitions), have the meaning given to them in the TOS or Custom Agreement, as applicable. Anaconda may, at any time, terminate this Agreement and the license granted hereunder if you fail to comply with any term of this Agreement. Anaconda reserves all rights not expressly granted to you in this Agreement.




1. Miniconda. In order to access some features and functionalities of Business, You may need to first download and install Miniconda.
2. Copyright Notice. Miniconda(R) (C) 2015-2024, Anaconda, Inc. All rights reserved under the 3-clause BSD License.
3. License Grant. Subject to the terms of this Agreement, Anaconda hereby grants You a non-exclusive, non-transferable license to: (1) Install and use Miniconda(R); (2) Modify and create derivative works of sample source code delivered in Miniconda(R) subject to the Anaconda Terms of Service (available at https://legal.anaconda.com/policies/en/?name=terms-of-service); and (3) Redistribute code files in source (if provided to You by Anaconda as source) and binary forms, with or without modification subject to the requirements set forth below.
4. Updates. Anaconda may, at its option, make available patches, workarounds or other updates to Miniconda(R). Unless the updates are provided with their separate governing terms, they are deemed part of Miniconda(R) licensed to You as provided in this Agreement.
5. Support. This Agreement does not entitle You to any support for Miniconda(R).
6. Redistribution. Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met: (1) Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer; (2) Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
7. Intellectual Property Notice. You acknowledge that, as between You and Anaconda, Anaconda owns all right, title, and interest, including all intellectual property rights, in and to Miniconda(R) and, with respect to third-party products distributed with or through Miniconda(R), the applicable third-party licensors own all right, title and interest, including all intellectual property rights, in and to such products.

EOF
    printf "\\n"
    printf "Do you accept the license terms? [yes|no]\\n"
    printf ">>> "
    read -r ans
    ans=$(echo "${ans}" | tr '[:lower:]' '[:upper:]')
    while [ "$ans" != "YES" ] && [ "$ans" != "NO" ]
    do
        printf "Please answer 'yes' or 'no':'\\n"
        printf ">>> "
        read -r ans
        ans=$(echo "${ans}" | tr '[:lower:]' '[:upper:]')
    done
    if [ "$ans" != "YES" ]
    then
        printf "The license agreement wasn't approved, aborting installation.\\n"
        exit 2
    fi

    printf "\\n"
    printf "%s will now be installed into this location:\\n" "${INSTALLER_NAME}"
    printf "%s\\n" "$PREFIX"
    printf "\\n"
    printf "  - Press ENTER to confirm the location\\n"
    printf "  - Press CTRL-C to abort the installation\\n"
    printf "  - Or specify a different location below\\n"
    printf "\\n"
    printf "[%s] >>> " "$PREFIX"
    read -r user_prefix
    if [ "$user_prefix" != "" ]; then
        case "$user_prefix" in
            *\ * )
                printf "ERROR: Cannot install into directories with spaces\\n" >&2
                exit 1
                ;;
            *)
                eval PREFIX="$user_prefix"
                ;;
        esac
    fi
fi # !BATCH
case "$PREFIX" in
    *\ * )
        printf "ERROR: Cannot install into directories with spaces\\n" >&2
        exit 1
        ;;
esac

if [ "$FORCE" = "0" ] && [ -e "$PREFIX" ]; then
    printf "ERROR: File or directory already exists: '%s'\\n" "$PREFIX" >&2
    printf "If you want to update an existing installation, use the -u option.\\n" >&2
    exit 1
elif [ "$FORCE" = "1" ] && [ -e "$PREFIX" ]; then
    REINSTALL=1
fi

total_installation_size_kb="636113"
total_installation_size_mb="$(( total_installation_size_kb / 1024 ))"
if ! mkdir -p "$PREFIX"; then
    printf "ERROR: Could not create directory: '%s'.\\n" "$PREFIX" >&2
    printf "Check permissions and available disk space (%s MB needed).\\n" "$total_installation_size_mb" >&2
    exit 1
fi

free_disk_space_kb="$(df -Pk "$PREFIX" | tail -n 1 | awk '{print $4}')"
free_disk_space_kb_with_buffer="$((free_disk_space_kb - 50 * 1024))"  # add 50MB of buffer
if [ "$free_disk_space_kb_with_buffer" -lt "$total_installation_size_kb" ]; then
    printf "ERROR: Not enough free disk space. Only %s MB are available, but %s MB are required (leaving a 50 MB buffer).\\n" \
        "$((free_disk_space_kb_with_buffer / 1024))" "$total_installation_size_mb" >&2
    exit 1
fi

# pwd does not convert two leading slashes to one
# https://github.com/conda/constructor/issues/284
PREFIX=$(cd "$PREFIX"; pwd | sed 's@//@/@')
export PREFIX

printf "PREFIX=%s\\n" "$PREFIX"

# 3-part dd from https://unix.stackexchange.com/a/121798/34459
# Using a larger block size greatly improves performance, but our payloads
# will not be aligned with block boundaries. The solution is to extract the
# bulk of the payload with a larger block size, and use a block size of 1
# only to extract the partial blocks at the beginning and the end.
extract_range () {
    # Usage: extract_range first_byte last_byte_plus_1
    blk_siz=16384
    dd1_beg=$1
    dd3_end=$2
    dd1_end=$(( ( dd1_beg / blk_siz + 1 ) * blk_siz ))
    dd1_cnt=$(( dd1_end - dd1_beg ))
    dd2_end=$(( dd3_end / blk_siz ))
    dd2_beg=$(( ( dd1_end - 1 ) / blk_siz + 1 ))
    dd2_cnt=$(( dd2_end - dd2_beg ))
    dd3_beg=$(( dd2_end * blk_siz ))
    dd3_cnt=$(( dd3_end - dd3_beg ))
    dd if="$THIS_PATH" bs=1 skip="${dd1_beg}" count="${dd1_cnt}" 2>/dev/null
    dd if="$THIS_PATH" bs="${blk_siz}" skip="${dd2_beg}" count="${dd2_cnt}" 2>/dev/null
    dd if="$THIS_PATH" bs=1 skip="${dd3_beg}" count="${dd3_cnt}" 2>/dev/null
}

# the line marking the end of the shell header and the beginning of the payload
last_line=$(grep -anm 1 '^@@END_HEADER@@' "$THIS_PATH" | sed 's/:.*//')
# the start of the first payload, in bytes, indexed from zero
boundary0=$(head -n "${last_line}" "${THIS_PATH}" | wc -c | sed 's/ //g')
# the start of the second payload / the end of the first payload, plus one
boundary1=$(( boundary0 + 34490480 ))
# the end of the second payload, plus one
boundary2=$(( boundary1 + 82636800 ))

# verify the MD5 sum of the tarball appended to this header
MD5=$(extract_range "${boundary0}" "${boundary2}" | md5)

if ! echo "$MD5" | grep bcaf076e244cdfee82376a3e77aa0a6a >/dev/null; then
    printf "WARNING: md5sum mismatch of tar archive\\n" >&2
    printf "expected: bcaf076e244cdfee82376a3e77aa0a6a\\n" >&2
    printf "     got: %s\\n" "$MD5" >&2
fi

cd "$PREFIX"

# disable sysconfigdata overrides, since we want whatever was frozen to be used
unset PYTHON_SYSCONFIGDATA_NAME _CONDA_PYTHON_SYSCONFIGDATA_NAME

# the first binary payload: the standalone conda executable
CONDA_EXEC="$PREFIX/_conda"
extract_range "${boundary0}" "${boundary1}" > "$CONDA_EXEC"
chmod +x "$CONDA_EXEC"

export TMP_BACKUP="${TMP:-}"
export TMP="$PREFIX/install_tmp"
mkdir -p "$TMP"

# Check whether the virtual specs can be satisfied
# We need to specify CONDA_SOLVER=classic for conda-standalone
# to work around this bug in conda-libmamba-solver:
# https://github.com/conda/conda-libmamba-solver/issues/480
# micromamba needs an existing pkgs_dir to operate even offline,
# but we haven't created $PREFIX/pkgs yet... give it a temp location
# shellcheck disable=SC2050

# Create $PREFIX/.nonadmin if the installation didn't require superuser permissions
if [ "$(id -u)" -ne 0 ]; then
    touch "$PREFIX/.nonadmin"
fi

# the second binary payload: the tarball of packages
printf "Unpacking payload ...\n"
extract_range "${boundary1}" "${boundary2}" | \
    CONDA_QUIET="$BATCH" "$CONDA_EXEC" constructor --extract-tarball --prefix "$PREFIX"

PRECONDA="$PREFIX/preconda.tar.bz2"
CONDA_QUIET="$BATCH" \
"$CONDA_EXEC" constructor --prefix "$PREFIX" --extract-tarball < "$PRECONDA" || exit 1
rm -f "$PRECONDA"

CONDA_QUIET="$BATCH" \
"$CONDA_EXEC" constructor --prefix "$PREFIX" --extract-conda-pkgs || exit 1

MSGS="$PREFIX/.messages.txt"
touch "$MSGS"
export FORCE

# original issue report:
# https://github.com/ContinuumIO/anaconda-issues/issues/11148
# First try to fix it (this apparently didn't work; QA reported the issue again)
# https://github.com/conda/conda/pull/9073
# Avoid silent errors when $HOME is not writable
# https://github.com/conda/constructor/pull/669
test -d ~/.conda || mkdir -p ~/.conda >/dev/null 2>/dev/null || test -d ~/.conda || mkdir ~/.conda

printf "\nInstalling base environment...\n\n"
if [ "$SKIP_SHORTCUTS" = "1" ]; then
    shortcuts="--no-shortcuts"
else
    shortcuts=""
fi
# shellcheck disable=SC2086
CONDA_ROOT_PREFIX="$PREFIX" \
CONDA_REGISTER_ENVS="true" \
CONDA_SAFETY_CHECKS=disabled \
CONDA_EXTRA_SAFETY_CHECKS=no \
CONDA_CHANNELS="https://repo.anaconda.com/pkgs/main/,https://repo.anaconda.com/pkgs/r/" \
CONDA_PKGS_DIRS="$PREFIX/pkgs" \
CONDA_QUIET="$BATCH" \
"$CONDA_EXEC" install --offline --file "$PREFIX/pkgs/env.txt" -yp "$PREFIX" $shortcuts --no-rc || exit 1
rm -f "$PREFIX/pkgs/env.txt"
mkdir -p "$PREFIX/envs"
for env_pkgs in "${PREFIX}"/pkgs/envs/*/; do
    env_name=$(basename "${env_pkgs}")
    if [ "$env_name" = "*" ]; then
        continue
    fi
    printf "\nInstalling %s environment...\n\n" "${env_name}"
    mkdir -p "$PREFIX/envs/$env_name"

    if [ -f "${env_pkgs}channels.txt" ]; then
        env_channels=$(cat "${env_pkgs}channels.txt")
        rm -f "${env_pkgs}channels.txt"
    else
        env_channels="https://repo.anaconda.com/pkgs/main/,https://repo.anaconda.com/pkgs/r/"
    fi
    if [ "$SKIP_SHORTCUTS" = "1" ]; then
        env_shortcuts="--no-shortcuts"
    else
        # This file is guaranteed to exist, even if empty
        env_shortcuts=$(cat "${env_pkgs}shortcuts.txt")
        rm -f "${env_pkgs}shortcuts.txt"
    fi
    # shellcheck disable=SC2086
    CONDA_ROOT_PREFIX="$PREFIX" \
    CONDA_REGISTER_ENVS="true" \
    CONDA_SAFETY_CHECKS=disabled \
    CONDA_EXTRA_SAFETY_CHECKS=no \
    CONDA_CHANNELS="$env_channels" \
    CONDA_PKGS_DIRS="$PREFIX/pkgs" \
    CONDA_QUIET="$BATCH" \
    "$CONDA_EXEC" install --offline --file "${env_pkgs}env.txt" -yp "$PREFIX/envs/$env_name" $env_shortcuts --no-rc || exit 1
    rm -f "${env_pkgs}env.txt"
done
# ----- add condarc
cat <<EOF >"$PREFIX/.condarc"
channels:
  - https://repo.anaconda.com/pkgs/main
  - https://repo.anaconda.com/pkgs/r
EOF

POSTCONDA="$PREFIX/postconda.tar.bz2"
CONDA_QUIET="$BATCH" \
"$CONDA_EXEC" constructor --prefix "$PREFIX" --extract-tarball < "$POSTCONDA" || exit 1
rm -f "$POSTCONDA"
rm -rf "$PREFIX/install_tmp"
export TMP="$TMP_BACKUP"


#The templating doesn't support nested if statements
if [ "$SKIP_SCRIPTS" = "1" ]; then
    printf "WARNING: skipping post_install.sh by user request\\n" >&2
else
    if ! "$PREFIX/pkgs/post_install.sh"; then
        printf "ERROR: executing post_install.sh failed\\n" >&2
        exit 1
    fi
fi

if [ -f "$MSGS" ]; then
  cat "$MSGS"
fi
rm -f "$MSGS"
if [ "$KEEP_PKGS" = "0" ]; then
    rm -rf "$PREFIX"/pkgs
else
    # Attempt to delete the empty temporary directories in the package cache
    # These are artifacts of the constructor --extract-conda-pkgs
    find "$PREFIX/pkgs" -type d -empty -exec rmdir {} \; 2>/dev/null || :
fi

cat <<'EOF'
installation finished.
EOF

if [ "${PYTHONPATH:-}" != "" ]; then
    printf "WARNING:\\n"
    printf "    You currently have a PYTHONPATH environment variable set. This may cause\\n"
    printf "    unexpected behavior when running the Python interpreter in %s.\\n" "${INSTALLER_NAME}"
    printf "    For best results, please verify that your PYTHONPATH only points to\\n"
    printf "    directories of packages that are compatible with the Python interpreter\\n"
    printf "    in %s: %s\\n" "${INSTALLER_NAME}" "$PREFIX"
fi

if [ "$BATCH" = "0" ]; then
    DEFAULT=yes
    # Interactive mode.

    printf "Do you wish to update your shell profile to automatically initialize conda?\\n"
    printf "This will activate conda on startup and change the command prompt when activated.\\n"
    printf "If you'd prefer that conda's base environment not be activated on startup,\\n"
    printf "   run the following command when conda is activated:\\n"
    printf "\\n"
    printf "conda config --set auto_activate_base false\\n"
    printf "\\n"
    printf "You can undo this by running \`conda init --reverse \$SHELL\`? [yes|no]\\n"
    printf "[%s] >>> " "$DEFAULT"
    read -r ans
    if [ "$ans" = "" ]; then
        ans=$DEFAULT
    fi
    ans=$(echo "${ans}" | tr '[:lower:]' '[:upper:]')
    if [ "$ans" != "YES" ] && [ "$ans" != "Y" ]
    then
        printf "\\n"
        printf "You have chosen to not have conda modify your shell scripts at all.\\n"
        printf "To activate conda's base environment in your current shell session:\\n"
        printf "\\n"
        printf "eval \"\$(%s/bin/conda shell.YOUR_SHELL_NAME hook)\" \\n" "$PREFIX"
        printf "\\n"
        printf "To install conda's shell functions for easier access, first activate, then:\\n"
        printf "\\n"
        printf "conda init\\n"
        printf "\\n"
    else
        case $SHELL in
            # We call the module directly to avoid issues with spaces in shebang
            *zsh) "$PREFIX/bin/python" -m conda init zsh ;;
            *) "$PREFIX/bin/python" -m conda init ;;
        esac
        if [ -f "$PREFIX/bin/mamba" ]; then
            # If the version of mamba is <2.0.0, we preferably use the `mamba` python module
            # to perform the initialization.
            #
            # Otherwise (i.e. as of 2.0.0), we use the `mamba shell init` command
            if [ "$("$PREFIX/bin/mamba" --version | cut -d' ' -f2 | cut -d'.' -f1)" -lt 2 ]; then
                case $SHELL in
                    # We call the module directly to avoid issues with spaces in shebang
                    *zsh) "$PREFIX/bin/python" -m mamba.mamba init zsh ;;
                    *) "$PREFIX/bin/python" -m mamba.mamba init ;;
                esac
            else
                case $SHELL in
                    *zsh) "$PREFIX/bin/mamba" shell init --shell zsh ;;
                    *) "$PREFIX/bin/mamba" shell init ;;
                esac
            fi
        fi
    fi

    printf "Thank you for installing %s!\\n" "${INSTALLER_NAME}"
fi # !BATCH
if [ "$TEST" = "1" ]; then
    printf "INFO: Running package tests in a subshell\\n"
    NFAILS=0
    (# shellcheck disable=SC1091
     . "$PREFIX"/bin/activate
     which conda-build > /dev/null 2>&1 || conda install -y conda-build
     if [ ! -d "$PREFIX/conda-bld/${INSTALLER_PLAT}" ]; then
         mkdir -p "$PREFIX/conda-bld/${INSTALLER_PLAT}"
     fi
     cp -f "$PREFIX"/pkgs/*.tar.bz2 "$PREFIX/conda-bld/${INSTALLER_PLAT}/"
     cp -f "$PREFIX"/pkgs/*.conda "$PREFIX/conda-bld/${INSTALLER_PLAT}/"
     if [ "$CLEAR_AFTER_TEST" = "1" ]; then
         rm -rf "$PREFIX/pkgs"
     fi
     conda index "$PREFIX/conda-bld/${INSTALLER_PLAT}/"
     conda-build --override-channels --channel local --test --keep-going "$PREFIX/conda-bld/${INSTALLER_PLAT}/"*.tar.bz2
    ) || NFAILS=$?
    if [ "$NFAILS" != "0" ]; then
        if [ "$NFAILS" = "1" ]; then
            printf "ERROR: 1 test failed\\n" >&2
            printf "To re-run the tests for the above failed package, please enter:\\n"
            printf ". %s/bin/activate\\n" "$PREFIX"
            printf "conda-build --override-channels --channel local --test <full-path-to-failed.tar.bz2>\\n"
        else
            printf "ERROR: %s test failed\\n" $NFAILS >&2
            printf "To re-run the tests for the above failed packages, please enter:\\n"
            printf ". %s/bin/activate\\n" "$PREFIX"
            printf "conda-build --override-channels --channel local --test <full-path-to-failed.tar.bz2>\\n"
        fi
        exit $NFAILS
    fi
fi

exit 0
# shellcheck disable=SC2317
@@END_HEADER@@
Ïúíş            @  …          H   __PAGEZERO                                                        x  __TEXT                  @              @                  __text          __TEXT          Äc     x¢      Äc               €            __stubs         __TEXT          <    T      <             €           __stub_helper   __TEXT          	    l      	              €            __cstring       __TEXT          ü    Ú!      ü                            __const         __TEXT          Ø.          Ø.                            __unwind_info   __TEXT          ì=    Ä      ì=                            __eh_frame      __TEXT          °?    P       °?                               è   __DATA_CONST     @     @       @      @                  __got           __DATA_CONST     @    (        @               G           __const         __DATA_CONST    (@    P       (@                               ˆ  __DATA           €     €       €      @                   __la_symbol_ptr __DATA           €    8       €               L           __data          __DATA          8‚           8‚                            __common        __DATA          H‚    Ì                                    __bss           __DATA          …    ì\                                       H   __LINKEDIT             À     À     pˆ                  "  €0    À    À X           `À x  ØÄ ¸        `× N   ŒŞ «
   P                   L                           @Ü “                             /usr/lib/dyld             T*8Ì64—üJA«.§©2                      *              (  €   Äc              ,       @                8         <   /usr/lib/libSystem.B.dylib      &      Ö Ğ   )      `×       €0      @loader_path/../../../../../              @é	0_                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     y ôO¾©ı{©ıC ‘ó ª( €¹	@ù  ‹? ë©  T€H Õã ”`@ùı{A©ôOÂ¨À_ÖÿƒÑúg©ø_©öW©ôO©ı{©ıC‘õªó ª  @ùà  µ`â‘U ÕÁ( ”` ùÀ ´h@ù©@¹	‹ €RÉ( ” ø7¶@¹àªÚ( ”ô ª€ ´¨B@9 q! Tàªáª €Òãª@  ”  52  ¨J ‘è ù@E Õ!EP Õ× ” €Ò-  ¨J ‘è[ © F0 Õ!F ÕÎ ”!   4 „R÷ªß
@ñØ2™šc@ùàªáª" €R˜( ”€ ´÷‹ÖëÁşÿT  ¨J ‘è ù ? Õ” ” €Ò  ¨J ‘è ù€Gp ÕáT0 Õ° ”àª†( ” €Ò`@ù`  ´g( ” ùàªı{E©ôOD©öWC©ø_B©úgA©ÿƒ‘À_ÖÿÃÑüo	©úg
©ø_©öW©ôO©ı{©ıƒ‘øªöªõª÷ ª ÕÈÑX@ù¨ƒøÿ# ¹ÿ ùÿ©ÿ/ ù¡Gp Õàc ‘€R¤ ”  4¨J ‘è ©àFP Õ] ” €g    „Rn( ”ó ªà ´ „R  „Ri( ”ô ªÀ ´¼
@¹Ÿ@ñ™3›šã@ùàª! €RâªD( ” ë¡	 Tà@ù.( ”@	 5œËù# ¹ó ùû; ¹ô ùàc ‘ €Rİ ”ù ª  q‚  Té€R)%Èi 7è;@¹zË– ´àª! €Râªãª4( ” ëÁ Tàª( ”  4  ø  ´àªáªâªA( ”‹è;@¹èûÿ4? q@  T¼ùÿµ? qa T €R  ¨J ‘è ù@30 Õ?p Õ7 ” €Ò €R   €  ¨J ‘è ùÀ10 Õ!@0 Õ+ ” €R
  ); Õ9Ùh¸¨J ‘èg © A Õü ” €àc ‘Ù# ”àªô' ”àªò' ”¨ƒZø ÕIÂX)@ù?ëA Tàªı{N©ôOM©öWL©ø_K©úgJ©üoI©ÿÃ‘À_Ö' ”ÿƒÑúg©ø_©öW©ôO©ı{©ıC‘÷ªó ªµ ” 1à T`â1‘õJ ‘áªû ”€ ´ô ª`@ùà  µ`â‘¡4 Õ¾' ”` ù€ ´h@ùé@¹	‹ €RÆ' ” ø7èB@9 qA Tàªáªâª €ÒBÿÿ—õ ªI   €Q  õ ù )P Õ¡) ÕØ ” €I  õ ù`$ ÕA$P ÕĞ ” €;    „R¼' ”  ´ö ªø@¹X 4 „R@ñ3™šc@ùàªáª" €R•' ”  ´àªáª" €Rãª›' ”  ´Ë8şÿµ €R  õ ù  ÕŒ ” €  õ ù€!0 Õ5p Õ© ” €  õ ù %p Õ30 Õ  õ ùà5p Õá5P Õ› ” €àªp' ”àª_' ”8€RN' ”`@ù`  ´N' ” ùàªK' ”àªı{E©ôOD©öWC©ø_B©úgA©ÿƒ‘À_ÖÿÃ ÑôO©ı{©ıƒ ‘ó ª ÕH¯X@ùè ù  @ùà  µ`â‘A% ÕC' ”` ù€
 ´¨'p Õ@ùè ù}XÓ1 è 9á ‘€R‡ ” 	 ´ô ª`@ùáª €R@' ”àø7àªBø€R" €R4' ”À ´h&E)	ÀZ)	ÀZh&)j.F)J	ÀZk	ÀZj.)ˆËa‘h ù*‚Rj*8Š  ĞKI¹`@ù	‹ €R&' ”t2€¹àª8' ”`
 ù` ´c@ùáª" €R' ”` ´h
@ùi2€¹	‹h ù`@ùş& ”€ 4 p Õ ”  € ÕAp Õ   p Õ0 Õ
  @0 Õ!0 Õ  Àp Õ¡0 Õ" ”  €è@ù Õ)£X)@ù?ë¡ Tı{B©ôOA©ÿÃ ‘À_Öàª
  ”`@ù`şÿ´Ï& ”  €R ùïÿÿ¡& ” 4@¹À_Ö
 A©_ë¢ TI-@))	ÀZk	ÀZI- )K1A)k	ÀZŒ	ÀZK1)IÁ)‹_	ëè T	ë	 T
@ù+1@)k	ÀZŒ	ÀZ+1 ),5A)Œ	ÀZ­	ÀZ,5))Á+‹_	ëişÿT  ÕÈ  À_ÖÿÑöW©ôO©ı{©ıÃ ‘õªôªó ª à‘á ù‚p Õ€€R' ”üq, T`â‘õ ù‚p Õ€€Rü& ”üqí  T  €Rı{C©ôOB©öWA©ÿ‘À_Öuâ!‘àªáª ”‚Rj(8‚R`‹áª€€R\& ”àª<ÿÿ—à  4`@ù€ıÿ´z& ”  €R ùèÿÿ  €Ræÿÿ @ùÀ_Ö( €¹	@ù( ‹?ë ŸšÀ_ÖôO¾©ı{©ıC ‘  €R‘‚RI& ”ó ªÀ  µ`	P Õa	0 Õ£  ”àªı{A©ôOÂ¨À_Öà ´ôO¾©ı{©ıC ‘ó ª @ù@  ´o& ”`@ù@  ´Q& ”àªı{A©ôOÂ¨h& À_Öø_¼©öW©ôO©ı{©ıÃ ‘óªô ª@ùàªÃ& ”—@ùßë¢ Tõ ªÈF@9½qÁ  TÀJ ‘áªâª¾& ”@ 4È€¹‰
@ùÖ‹?ëˆ  TÿëHşÿT  @õ ÕI  ”  €Òı{C©ôOB©öWA©ø_Ä¨À_ÖÈ‹	-A8? q ˆš÷ÿÿöW½©ôO©ı{©ıƒ ‘XA©ëB Tôªõ ª`J ‘áª‰& ”  4h€¹©
@ùs‹?ëˆ  TßëÈşÿT  àğ Õ&  ” €Òàªı{B©ôOA©öWÃ¨À_Öâªá ª ÕÈ‡X @ù’& ÿƒ Ñı{©ıC ‘á ª Õˆ†X@ùè ù¨C ‘è ù Õ†X @ù¢C ‘ƒ& ”è@ù Õ	…X)@ù?ë  Tı{A©ÿƒ ‘À_Ö¹% ”ÿCÑöW©ôO©ı{©ı‘ó ª Õ(ƒX@ùè ù Õõ‚X´@ùÿ% ”à ù¡0 Õàªå% ”¨C ‘è ù @ù¢C ‘áª`& ”è@ù Õ©€X)@ù?ëÁ  Tı{D©ôOC©öWB©ÿC‘À_Ö”% ”ÿÃ ÑôO©ı{©ıƒ ‘ó ª Õ¨~X@ùè ù¨C ‘è ù Õ(~X @ù¢C ‘D& ”àª÷% ”è@ù Õé|X)@ù?ë¡  Tı{B©ôOA©ÿÃ ‘À_Öw% ”ÿÑôO
©ı{©ıÃ‘âªó ª ÕèzX@ù¨ƒø¨C ‘è ù£C ‘€€R+& ”üqm  T  €  á# ‘àª÷% ”¨ƒ^ø ÕÉxX)@ù?ë¡  Tı{K©ôOJ©ÿ‘À_ÖV% ”ÿÃ ÑôO©ı{©ıƒ ‘óªô ªâ ùÂëp Õ€€RŞ% ”üqì TàªA€Râ% ”` ´á ª? 8àªã% ”ˆ@9¨  4h@9 qàŸZ    €ı{B©ôOA©ÿÃ ‘À_ÖöW½©ôO©ı{©ıƒ ‘ A©? ëB Tó ª4 €R5 €R ¨r(D@9iQy qˆ"È
™@z! Tàª|üÿ—á ªh@ù ëƒşÿT  €R    €Rı{B©ôOA©öWÃ¨À_Öüoº©úg©ø_©öW©ôO©ı{©ıC‘ÿ@ÑÿÃÑ ÕˆnX@ù¨ø ä oàƒ„<àƒ…<àƒ†<àƒ‡<àƒˆ<àƒ‰<àƒŠ<àƒ‹<àƒŒ<ÿo ùà# ù A©¿ëB Tóªô ª¹ã ÕÖàp Õø@‘ƒ‘ûƒ3‘  àªáªRıÿ—  5àªáªDüÿ—õ ªˆ@ù ë¢ T¨F@9iQy qÈşÿT©şÿ*kh8)	
‹ Ö³ıÿ´àªáª‚ ”éÿÿ¨J ‘ü#@ùè ùà@‘ €‘€€Râªd% ”üql Tà@‘ €‘A€Rg% ”À ´á ª? 8àƒ3‘€€RË$ ”è‡‘ı9È 4èƒs9ˆ 4àƒ‘á@‘!€‘~ ”™ã!‘è€Rèï©ú€R÷ƒ‘úß ©àƒ#‘ù ùğ0 Õ;ÿÿ—À 4úï©úß©¨ğP Õú£ ©àƒ#‘ù ùïp Õ0ÿÿ—` 4àƒ‘è€Rèã ©ù ù!ï0 Õ(ÿÿ—ú‘  4àƒ‘è€Rèã ©ù ùaî Õÿÿ—  4àƒ‘è€Rèã ©ù ù¡íp Õÿÿ—` 5øªàª« ” 1À Tû'@ùÛ ´V €R`ã‘áƒ‘ % ”€ 4[{vøÖ ‘[ÿÿµ× Q  àª› ” 1à	 Tã1‘àƒ#‘âƒ3‘` ” 1 TH  7 €R,şÿ—€
 ´û ª à‘èƒ‘è ù€€Röªâªø$ ”üq T`ã!‘ù ù€€Râªñ$ ”üq, T`ã1‘ˆã1‘è ù€€Râªé$ ” q* T	‚Rˆki8hk)8àª7ıÿ—À 5[{7ø|#A©Ÿëöªø@‘ƒ‘B T€K ‘áƒ3‘ã$ ”  4àªáªšûÿ—ü ªh@ù ëÃşÿT  àªáªœüÿ— 1  Tûƒ3‘9Ë ÕFÿÿ €Rà'@ùÀ µ"  èƒ3‘è ù â0 Õ  èƒ3‘è ùÀŞ Õ  Àáp Õ  èƒ‘è ù âP Õdşÿ—àªéıÿ—èƒ‘è ùàŞP Õ]şÿ— €à'@ùÀ  ´è‘A ‘Şıÿ—€†@øÀÿÿµ¨Zø ÕINX)@ù?ëa Tàªÿ@‘ÿÃ‘ı{E©ôOD©öWC©ø_B©úgA©üoÆ¨À_Öü# ”üoº©úg©ø_©öW©ôO©ı{©ıC‘ÿÃÑó ª Õ(KX@ù¨ø@ù Õ Õ¨cXàÎp Õ ?Ö  ´õ ª Õ Õ(dX ?Ö€ ´h@ùŸëâ
 Tö ª‚R|‹×c ÕyÒ Õ
  àª$ ”àªáª+ûÿ—ô ªh@ù ëÂ TˆF@9ÍqáşÿTàªáª1ûÿ—ú ª˜J ‘àƒ ‘è€Rèã ©ü ù€€RÌp ÕP$ ” q
	 T Õ ÕÈaXàƒ ‘ ?Öû ªè@ùàªÌp Õâª ?Ö Õ ÕXXàª ?Ö Õ Õ(bX@¹àª ?Ö` ´û ªè@ùàªáªâª ?Ö Õ ÕH`Xàªáªâª ?Ö øÿµ Õ ÕˆWX ?Öø ù É0 ÕÕıÿ—  €R
  @Ã Õ    €R   Ã ÕËıÿ—  €¨Zø Õé<X)@ù?ë¡ TÿÃ‘ı{E©ôOD©öWC©ø_B©úgA©üoÆ¨À_ÖàÂ0 Õîÿÿø ù Ä Õµıÿ— Õ ÕˆRX ?Öæÿÿg# ”À_ÖöW½©ôO©ı{©ıƒ ‘ó ª{ ”  5(‚R) €Rij(8àªW ”à  5àª• ”€  5àª' ”À  4  €ı{B©ôOA©öWÃ¨À_Ö¶I ÕÈ@ù@ùˆ µ@ €R €ÒÓ# ”ê# ”ô ªÂ Õ@ €RÍ# ”  €R­# ”õ ª@ €RáªÇ# ”àª}# ”È@ù ùàªı{B©ôOA©öWÃ¨6ÿÿS À_Öúg»©ø_©öW©ôO©ı{©ı‘ÿƒ0Ñôªõ ª Õˆ1X@ù¨ƒøßüÿ—  ´ó ª@ùàc ‘’ ”` 4àc ‘ác ‘Ú ”à 4àc‘ác ‘® ”` 4€ÁP Õ ”ö ª  ´@Á Õ ”à ´÷ ª!Á0 Õ¥# ”  qøŸàªG# ”À¿ Õ ”   €R  8 €R€¾P Õû ”ác ‘âc ‘àªvüÿ—  7÷c ‘ùc ‘ác ‘âc ‘àªoüÿ—à 6v ´u~¹tB
ùÖ  µàª±ıÿ—  qèc‘Ÿš-
 ”à ùø 5÷ ªáª €Ò ”@ 5àªáª'	 ”€  5àª§	 ”€ 4àª¤ ”àC ‘,
 ”v ´àc‘áªk# ”@ 4tâ1‘ö ù›p Õàª€€RW# ”üqL T‚R) €Rij(8‚R`‹áª€€RÀ" ”àªRÿÿ—àªQÿÿ—ô ªàªƒÿÿ—à@ùƒ ”àC ‘
 ”  ù_ © µp Õòüÿ—  àc ‘?  ”€÷ÿ4èc ‘è © ·P Õ÷ÿÿác ‘àª` ”öùÿµá@ùàª„ıÿ—  4 €¨ƒ[ø Õ©X)@ù?ë! Tàªÿƒ0‘ı{D©ôOC©öWB©ø_A©úgÅ¨À_Övâ1‘hâq9 qèc‘–šÀ¯P Õƒ ”àªÃ ” 1ÀüÿTNÿÿ—àc ‘áªâªãªş ”ô ªà@ùG ”àC ‘Ï	 ”‚Rhjh8h  4àª ”àª;üÿ—« ”Óÿÿi" ”ÿÃ ÑôO©ı{©ıƒ ‘ ÕhX@ùè ùÁ Õ—" ”à ´ó ª(’p Õ@ùè ù}XÓ5 è 9á ‘€RÛ ”   ´  €R    €  àªu" ”  €Rè@ù ÕéX)@ù?ë¡  Tı{B©ôOA©ÿÃ ‘À_Ö?" ”ôO¾©ı{©ıC ‘ÿCÑó ª ÕX@ù¨ƒøá ù‚ˆp Õà# ‘€€RÃ" ”üqm  T  €R  à# ‘?" ”à ù‡p Õàª€€R·" ” qà§Ÿ¨ƒ^ø ÕéX)@ù?ë¡  TÿC‘ı{A©ôOÂ¨À_Ö" ”ôO¾©ı{©ıC ‘ó ªàª" ”á ªàª°" ”  €Rı{A©ôOÂ¨À_ÖÿÑöW©ôO©ı{©ıÃ ‘ôªó ªá ù"‚p Õ€€R‘" ”øqˆ T|@“	‹)ñ_8?½ q€  Té€Rij(x	 ‘	€€R5Ëàª›" ” ëÂ T ‹ñ_8àªáªâª–" ”ß¾ qá  Tàª" ” ‹ñ8   €Òàªı{C©ôOB©öWA©ÿ‘À_Öı{¿©ı ‘á ªàªV" ”  ñàŸı{Á¨À_ÖÿÃÑı{
©ıƒ‘ ÕˆX@ù¨ƒøá# ‘^" ”  qàŸ¨ƒ_ø ÕiX)@ù?ë  Tı{J©ÿÃ‘À_Ö¼! ”ÿCÑöW
©ôO©ı{©ı‘óªô ª ÕhX@ù¨ƒø šp Õ¤ ”à ´á™ Õa" ”` ´á ªU™ Õ    €ÒáªY" ”á ª@ ´àªâª”ÿÿ— ÿÿ´á# ‘àª/" ”€şÿ5  €R¨ƒ]ø Õ‰ÿX)@ù?ëÁ  Tı{L©ôOK©öWJ©ÿC‘À_Ö‹! ”ôO¾©ı{©ıC ‘ÿCÑó ª ÕˆıX@ù¨ƒø€€Rè ¹à# ‘á ‘t! ”À  4À“P ÕÁûÿ—  €R  à# ‘áªõ! ”  ñàŸ¨ƒ^ø ÕéúX)@ù?ë¡  TÿC‘ı{A©ôOÂ¨À_Ög! ”ôO¾©ı{©ıC ‘ÿCÑó ª ÕùX@ù¨ƒøá ù‚mp Õà# ‘€€Rë! ”üqm  T  €R  à# ‘g! ”à ùlp Õàª€€Rß! ” qà§Ÿ¨ƒ^ø ÕéõX)@ù?ë¡  TÿC‘ı{A©ôOÂ¨À_Ö?! ”ÿƒ Ñı{©ıC ‘á ù¢ŒP Õ€€RÊ! ” qà§Ÿı{A©ÿƒ ‘À_ÖÿÃÑı{
©ıƒ‘ Õ¨òX@ù¨ƒøá# ‘ƒ! ”  qè·Ÿé@y)?)@qéŸªƒ_ø ÕñXk@ù
ë¡  T 	
ı{J©ÿÃ‘À_Ö! ”ôO¾©ı{©ıC ‘ôªó ªá‡0 Õ1! ”ˆ   -ùà/ ´A‰0 Õàª*! ”ˆ   1ù`/ ´ÁŠ0 Õàª#! ”ˆ   5ùà. ´A‹p Õàª! ”ˆ   9ù`. ´Œp Õàª! ”ˆ   =ùà- ´!0 Õàª! ”ˆ   Aù`- ´A0 Õàª! ”ˆ   Eùà, ´áp Õàª ! ”ˆ   Iù`, ´p Õàªù  ”ˆ   Mùà+ ´ŸÎq Tap Õàªğ  ”ˆ   Qùà+ ´á0 Õàªé  ”ˆ   Uù@* ´a‘p Õàªâ  ”ˆ   YùÀ) ´Á‘0 ÕàªÛ  ”ˆ   ]ù ) ´!’p ÕàªÔ  ”ˆ   aù ) ´’0 ÕàªÍ  ”ˆ   eù ( ´“p ÕàªÆ  ”ˆ   iù ( ´a“p Õàª¿  ”ˆ   mù ' ´Á“p Õàª¸  ”ˆ   qù ' ´¡”0 Õàª±  ”ˆ   uù & ´a•0 Õàªª  ”ˆ   yù & ´a–0 Õàª£  ”ˆ   }ù % ´Á–p Õàªœ  ”ˆ   ù % ´a—p Õàª•  ”ˆ   …ù $ ´á—0 Õàª  ”ˆ   ‰ù $ ´A˜p Õàª‡  ”ˆ   ù # ´á˜0 Õàª€  ”ˆ   ‘ù # ´!š0 Õàªy  ”ˆ   •ù " ´›0 Õàªr  ”ˆ   ™ù " ´!œp Õàªk  ”ˆ   ù ! ´A0 Õàªd  ”ˆ   ¡ù ! ´Áp Õàª]  ”ˆ   ¥ù   ´!p ÕàªV  ”ˆ   ©ù   ´Á0 ÕàªO  ”ˆ   ­ù  ´Ÿ0 ÕàªH  ”ˆ   ±ù  ´ p ÕàªA  ”ˆ   µù  ´¢p Õàª:  ”ˆ   ¹ù  ´!£p Õàª3  ”ˆ   ½ù  ´A¤p Õàª,  ”ˆ   Áù  ´Á¤p Õàª%  ”ˆ   Åù  ´¦0 Õàª  ”ˆ   Éù  ´á¦p Õàª  ”ˆ   Íù  ´¡§0 Õàª  ”ˆ   Ñù  ´A¨p Õàª	  ”ˆ   Õù  ´©0 Õàª  ”ˆ   Ùù  ´©p Õàªû ”ˆ   ù  ´Aª0 Õàªô ”ˆ   ù  ´á«0 Õàªí ”ˆ   İù  ´á¬0 Õàªæ ”ˆ   áù  ´­p Õàªß ”ˆ   åù  ´!®0 ÕàªØ ”ˆ   éù  ´!¯0 ÕàªÑ ”ˆ   ñù  ´á¯0 ÕàªÊ ”ˆ   íù  ´!±p ÕàªÃ ”ˆ   õù  ´á±p Õàª¼ ”ˆ   ùù  ´²p Õàªµ ”ˆ   ıù  ´  €R§   XP Õ¢   ZP ÕŸ  €[p Õœ   ] Õ™  `^0 Õ–  À_ Õ“   a0 Õ  @bP Õ   cP ÕŠ  @fp Õ‡  @g0 Õ„   dp Õ  Àg0 Õ~   h0 Õ{  €ip Õx  €jP Õu  `kP Õr  €l0 Õo  ÀmP Õl   oP Õi  `p0 Õf  `qP Õc  `rp Õ`  `s0 Õ]  `t0 ÕZ  ÀuP ÕW  `w ÕT  àx0 ÕQ  €z0 ÕN  À{p ÕK  À|P ÕH  À}0 ÕE  à~P ÕB  @€p Õ?   ‚ Õ<  àƒP Õ9  €…P Õ6  à† Õ3   ˆp Õ0  À‰0 Õ-   ‹p Õ*  @Œ0 Õ'  `p Õ$  €p Õ!   p Õ  `‘ Õ   “P Õ  €”0 Õ   •0 Õ  à–P Õ  @˜P Õ  À™p Õ	  `› Õ  €œP Õ  À0 Õ2ùÿ—  €ı{A©ôOÂ¨À_Öüo½©ôO©ı{©ıƒ ‘ÿƒÑó ª ÕÈ¨X@ù¨ƒøà ‘ô ù"p Õàc ‘€Rh ” q T|@“	€Rô§ ©è ù ›0 Õ  ‚Rs‹àc‘âc ‘áª½üÿ—À  µ€€Ró# ©à› Õùÿ—óc‘àc‘ı
 ”À  ´ Õ Õa¶¡ıÿ—  Ñ ”ó © ›P Õúøÿ—  €¨ƒ]ø ÕÉ¢X)@ù?ëÁ  Tÿƒ‘ı{B©ôOA©üoÃ¨À_Ö¥ ”  €RÀ_ÖöW½©ôO©ı{©ıƒ ‘ó ª  @ù  ´t" ‘•¾ Õ¨@ù ?Ö€†@ø ÿÿµàªı{B©ôOA©öWÃ¨Õ ÿƒÑúg©ø_©öW©ôO©ı{©ıC‘öªõ ª@ €R €Ò ”( ”` ´ó ª¨  }}“! €R‰ ”ô ªà ´á( Õ@ €R ”¿ që T €Òø*Y¹ Õ(@ùúò}ÓÀjzø €Ò ?Ö€j:ø@ ´÷ ‘ëáşÿTŸÚ5ø@ €Ráªğ ”àª¦ ”  `’0 Õ   ’0 Õ¢øÿ—  €@ù  ´•" ‘öµ ÕÈ@ù ?Ö †@ø ÿÿµàª“ ”àª‘ ”è ‘è ù  Õøÿ— €Òàªı{E©ôOD©öWC©ø_B©úgA©ÿƒ‘À_ÖÿÑöW©ôO©ı{©ıÃ ‘ôªó ª Õ¨“X@ùè ùâ ù@ €R €Ò¼ ”Ó ”5¥ Õ  ùá Õ@ €R´ ” Õ Õˆ¯Xá ‘àª ?Öô ª¡@ù@ €Rª ”t ´â@ùàªáªá ” Õ Õè­Xàª ?Ö   €Òè@ù ÕÉX)@ù?ëá  Tàªı{C©ôOB©öWA©ÿ‘À_Ö ”üoº©úg©ø_©öW©ôO©ı{©ıC‘ÿ@ÑÿƒÑó ª ÕŒX@ù¨ø@0 Õé ”  ´ô ª Õ ”à 4¡0 Õàªˆ ”  4ô ùÀ›P Õ,øÿ—%  @ €R €Òm ”€  ´ƒ ”ô ª   €Òá Õ@ €Rd ”õ ªÀ ´A›P Õàªp ”  4Áš Õàªk ”`  4 €R  5 €RÔ  ´@ €RáªQ ”àª ”u  6( €R   €R Õ Õi™X( ¹aâ‘à
 Õ€€Rxÿÿ—  ´ Õ Õ(šXà
 Õ ?Ö‚Rt‹ 	 Õáª€€Rjÿÿ—@ ´ Õ Õ¨˜X 	 Õ ?ÖH€R+€0 ÕèÓ©é€R* Õê#© ¨ Õâ}0 Õé¯©ô ùô' ©„R" ”€0q‹ T„Rô# © ~0 Õ¯  Ày0 Õ¬   z Õ©  à Õ¡¥ Õ„R?ÿÿ—` ´ Õ ÕÈ’X ?Ö Õ Õ’X  Õ ?Öt
@ù Õ ÕhX7 €R ¹ Õ ÕHX ¹ Õ ÕHŒX ¹ Õ ÕX ¹ Õ ÕŒX ¹ØŒ Õ@ù ¹h@ùŸë
 T €RU‹P ÕZ‹ Õ[“ Õïp Õ
  H@ù ¹àªáªŸôÿ—ô ªh@ù ë‚ TˆF@9½qáşÿT–J ‘àªáª‚ €Rê ” şÿ4ÈÀ9=Q q¨ıÿTIıÿŠkh8)	
‹ Ö–R ‘à3‘áª€€R‹ ” ±  Th@ùà3‘ ?ÖŞÿÿ9 €RÜÿÿ@ùÙÿÿ@rP ÕE  9 4 Õ4qX€@ùL ” Õ5pX @ùH ” ÕèoX @ù €Ò— ”€@ù €Ò” ” @ù €Ò‘ ” Õ Õ¨‚X) €R	 ¹ Õ ÕˆƒX ?Ö Õ ÕHŠX`ö Õ ?Ö`~T¹aBJùişÿ—€ ´ô ª Õ Õ(ˆX`~T¹áª €R ?Ö€@ù  ´“" ‘µˆ Õ¨@ù ?Ö`†@ø ÿÿµàª) ” Õ Õ(X ?Ö  ´ kp Õ  À~0 Õ!÷ÿ—  €¨Zø Õ©gX)@ù?ëá Tÿ@‘ÿƒ‘ı{E©ôOD©öWC©ø_B©úgA©üoÆ¨À_Öö ù zp Õ÷ÿ—ÀÿÿÃ ”ÿÃÑüo©úg©ø_©öW©ôO©ı{©ıƒ‘ó ª Õ Õ¨‚X	‚R  	‹ ?Ö  ´á ª Õ Õ(€X€g Õ ?Öt"A©Ÿë‚ TW‚ ÕÕf0 Õ˜y Õ™y ÕÚx Õ[z Õ
  àªß ”àªáªñóÿ—ô ªh@ù ëÂ TˆF@92µqÁşÿTàªáªöóÿ—ö ªè@ù@¹ ?ÖÀ  ´á ªh@ù€J ‘ ?Ö   µˆJ ‘è ùàªÆöÿ—@ù ?Ö üÿ´(@ù ?ÖH@ù ?ÖÛÿÿ  €R  à^p Õ¹öÿ—  €ı{F©ôOE©öWD©ø_C©úgB©üoA©ÿÃ‘À_ÖÿÑöW©ôO©ı{©ıÃ ‘@ù)@¹	‹ Õ ÕhwX à‘ ?Öô ª Õ ÕhvXàO © ] Õ ?Öó ªµl Õ¨@ùàª ?Ö Õ ÕHsX`\ Õ ?Ö€ ´ Õ ÕhoXáª ?Öó ª€ 4`\0 Õ„öÿ—   Z0 Õ€öÿ—¨@ùàª ?Ö €àªı{C©ôOB©öWA©ÿ‘À_ÖÿÃÑüo©úg©ø_©öW©ôO©ı{©ıƒ‘ A©Ÿë¢ Tó ªà‘˜o ÕÖV Õf Õ\m ÕWV Õ   V0 Õ[öÿ—(@ùàª ?Öàªáªgóÿ—ô ªh@ù ëb TˆF@9éqáşÿTh@ù‰@¹	‹ Õ ÕÈkXàª ?Öû ª@ùàk ©àª ?Öú ª(@ùàª ?Öˆ@ùàª ?Ö€ûÿ´ Õ ÕÈdXáª ?Ö€ûÿ4àQ0 Õ0öÿ—Øÿÿ  €Rı{F©ôOE©öWD©ø_C©úgB©üoA©ÿÃ‘À_ÖôO¾©ı{©ıC ‘(‚Rhh8h 43d Õh@ù Pp Õ €Ò ?Öh@ù T Õ €Ò ?Ö Õ Õà[Xı{A©ôOÂ¨  Öı{A©ôOÂ¨À_Öüoº©úg©ø_©öW©ôO©ı{©ıC‘óªöªõ ªôª" ´ B ‘áª€Rg ” B‘B ‘€Rc ” B0‘Â ‘€R_ ” B ‘Áâ!‘‚‚ ‘ùÿ—ˆB@¹	ÀZ»¹h }@“  €R¬ ”ø ª 
ùˆJ@¹	ÀZ¨*¹}@“àªõ ”ù ª ùˆR@¹	ÀZ¨:¹}@“àªí ” ù ñ$@ú@úA TÀU ÕĞõÿ—)  Á"A©? ëÂ T(D@9àª±qà TÙòÿ—á ªÈ@ù ëÿÿT  ú ªˆF@¹	ÀZ‹b@“àªÙ ”ˆN@¹	ÀZ‹àªâªÓ ”ˆV@¹	ÀZ‹àªâªÍ ”s  µàª© ”  €R  Ëòÿ—ô ª õÿµ  €ı{E©ôOD©öWC©ø_B©úgA©üoÆ¨À_ÖôO¾©ı{©ıC ‘ A©? ëb Tó ª(D@9±q` Tàª¥òÿ—á ªh@ù ëÿÿT  €Òı{A©ôOÂ¨À_Öàªı{A©ôOÂ¨©òÿöW½©ôO©ı{©ıƒ ‘ôªó ªÕV Õ¨@ù A
 Õ ?Öh"HùÈ ´h&Hùˆ ´ Õ ÕˆSXàª ?Ö Õ Õ(TX`" ‘¡  Õâª €R €R ?Ö  4 I0 Õdõÿ— Õ Õ(SX >
 Õ ?Öàªæ  ”  €ı{B©ôOA©öWÃ¨À_Ö¨@ùó<
 Õàª ?Ö5Q Õ¨@ùÀ;
 Õ ?Ö Õ ÕèPX”;
 Õàªáª €Ò ?Ö¨@ùàª ?Ö Õ ÕèNXàª ?Ö  €Rßÿÿúg»©ø_©öW©ôO©ı{©ı‘ó ª÷L Õè@ùÀ7
 Õ ?Ö¸  °ƒ9 Õ Õ¨IX ?Ö` ùh@ùè  µ Õ ÕˆJX ?Ö` ù`@ùšL ÕH@ùHP ÕbW  Õãª €Ò ?Öô ªH@ù`@ùGP ÕbV  Õãª €Ò ?Öõ ªH@ù`@ùÁFP Õ‚g  Õãª €Ò ?Öö ªyJ Õ(@ù`@ùaEp Õ € €R ?ÖH@ù`@ùaE0 Õ‚Z  Õãª €Ò ?ÖŸ ñ¤@úÄ@ú@úõC Õ6D ÕÀ T Õ Õˆ@X`@ù ?Öô ª Õ ÕGX`@ù ?Ö *( 5 Õ Õ(DX`Hùa*P¹ ?Öã ª Õ ÕˆCX`@ù¡@ Õ €Ò$ €R ?Ö`HùÁ ”ù(@ù`@ùa
HùbP¹# €R ?Öè@ù´)
 Õàª ?ÖÈ@ù@)
 Õ ?Ö¨@ùàª ?ÖB Õˆ@ù ?Ö qË TƒG9ˆ 5Y: Õ(@ù  €R ?Öˆ@ù ?ÖƒG9 q ©@z ÿÿTàª&  ”¨@ù@%
 Õ ?Öè@ù%
 Õàª ?ÖÈ@ù $
 Õ ?Ö¨@ùàª ?Ö Õ Õè6X ?Öè@ù“#
 Õàª ?ÖÈ@ù`#
 Õ ?Ö¡@ùàªı{D©ôOC©öWB©ø_A©úgÅ¨  ÖÿƒÑø_©öW©ôO©ı{©ıC‘ ÕèX@ùè ùÀ ´ó ªˆ‚Rhh8 q!
 Tt@ù Õ Õè2X ?Öè ª`@ùŸë  T` ´V2 ÕÈ@ùô
 Õàª ?Ö7 €R¨  °9ÿ ¹ÿ ù Õ Õ5X €R ?Öõ ªh.  Õ  ù ù` 9è# ‘éS ‘$©|©È@ù–
 Õàª ?Ö Õ ÕH/X`@ùáª €R ?Ö Õ Õ¨.X`@ù ?Ö- Õè@ùàª ?Ö Õ Õè,XU
 Õàªáª €Ò ?Öè@ùàª ?Ö Õ Õè*Xàª ?Ö Õ Õˆ(X ?Ö`"Hù`  ´ ”"ù`&Hù`  ´
 ”&ùè@ù Õ‰X)@ù?ëá T  €Rı{E©ôOD©öWC©ø_B©ÿƒ‘À_Ö`şÿ´ Õ ÕÈ%X ?Ö ùíÿÿ² ”üoº©úg©ø_©öW©ôO©ı{©ıC‘ÿƒ Ñôªõ ª ÕÈX@ù¨ø  €R‚€R­ ”ó ªˆ:P¹( 4 €Ò €RwJ ‘–B0‘  z 7 ñúŸàª? ”h ‹ ‘ˆ:¹ë‚ TˆHù‹àªáª•óÿ—ø ª şÿ´€¹àªáªƒ‚€R€ ”K ‘àªáªâªu÷ÿ—@¹àª& ”œ Kàª# ”ˆ h ¹àªáª×ñÿ—`ûÿ4ú ùÀp Õ¶óÿ—4 €&  Ø  ´¡â1‘àC ‘âª^÷ÿ—  ¡â!‘àC ‘€€R ”•B ‘àC‘áª€€R ”áC ‘âC‘àªP÷ÿ—•B‘àC‘áª€€R ”áC ‘âC‘àªG÷ÿ—”B ‘àC‘áª6÷ÿ—áC ‘âC‘àª?÷ÿ— €RàªŠ ”¨Zø ÕIõX)@ù?ë Tàªÿƒ ‘ı{E©ôOD©öWC©ø_B©úgA©üoÆ¨À_Öù ù€p Õzóÿ— €êÿÿ/ ”ôO¾©ı{©ıC ‘ó ªˆ‚R ‹Ÿ 9 @ ‘f ”`"ù`B‘c ”á ª`&ù`"Hù  ñ$@ú¡  T p Õbóÿ—   ”  ø7  €R( €Rˆ 9    €ı{A©ôOÂ¨À_ÖÿƒÑø_©öW©ôO©ı{©ıC‘óªôªõªö ª ÕhíX@ùè ùÿ ¹ÿ ù Õ ÕÈX €R ?Ö÷ ª(  Õ  ù ù` 9è# ‘éS ‘$©P© Õ ÕhX ú	 Õ ?Ö Õ ÕèXÀ@ùáª €R ?Ö Õ ÕHXÀ@ù ?Öõ  4 Õ ÕHX ÷	 Õ   Õ ÕHXóö	 Õà# ‘áª €Ò ?Ö Õ Õh	Xàª ?Ö Õ Õ	Xà# ‘ ?Öà@¹è@ù Õ	åX)@ù?ëá  Tı{E©ôOD©öWC©ø_B©ÿƒ‘À_Ö¶ ”ôO¾©ı{©ıC ‘  €R
‚R¼ ”ó ªÀ  µÀWP ÕA0 Õóÿ—àªı{A©ôOÂ¨À_ÖôO¾©ı{©ıC ‘ó ª @ù” ´€
Hù@  ´á ”€Hù@  ´Ş ”€Hù@  ´Û ”àªÙ ” ùı{A©ôOÂ¨À_ÖöW½©ôO©ı{©ıƒ ‘ó ª@ùÈ ´`
@ùa@ù ?Öô ªhb@9h 5 Õ ÕÈÿXuì	 Õàª ?Ö`"B© ¹ Õ ÕhÿX ?Ö Õ ÕhşXàª ?Ö  €Rı{B©ôOA©öWÃ¨À_Ö €Rhb@9(ÿÿ5æÿÿı{¿©ı ‘ Õ Õ(şX  @ù#H ‘Aù Õ €Ò$ €R ?Ö  €Rı{Á¨À_ÖÿCÑöW©ôO©ı{©ı‘óªô ª Õ×X@ùè ùÿ ¹ÿ ù Õ ÕhıX €R ?Öõ ªÈöÿ Õ  ù( €R` 9è# ‘éS ‘$©Èúÿ Õ ùL© Õ Õ¨öXSã	 Õàª ?Ö Õ Õ÷X€@ùáª €R ?Ö Õ ÕhöX€@ù ?Ö Õ ÕˆôXàª ?Öà@¹è@ù ÕÉĞX)@ù?ëÁ  Tı{D©ôOC©öWB©ÿC‘À_Ö ”  €RÀ_Öüo¼©öW©ôO©ı{©ıÃ ‘ÿCÑôªóªõ ª ÕÎX@ù¨ƒøöò ÕÈ@ù`@ù ?Ö¡í Õ€R® ”`  4  €R  µB ‘È@ù€@ù ?Öâ ªà# ‘áªéõÿ— Õ Õ¨ïXëp Õàª €Òãª$ €R ?Ö Õ Õ(ğXá# ‘àª ?Ö¨ƒ\ø ÕéÈX)@ù?ëá  TÿC‘ı{C©ôOB©öWA©üoÄ¨À_ÖÕ ”öW½©ôO©ı{©ıƒ ‘öªóªôª Õ Õ¨ëXI Q`Øiø ?Ö÷õÿ—` 4 Õ Õ¨ìX`rS ?Öõ ª Õ Õ(êX åP Õ € ?Ö  ù
 q‹ Tè*
 Ñ_ ñã T©" ‘ñ}Ó¬‹Í" ‘Ë‹?ë€1Múè TKõ~’i@²Ìb ‘­b ‘îª€…­ …?­Œ ‘­ ‘Î ñaÿÿT_ëa  T
  ) €R+ñ}Óª‹Ë‹	Ëi…@øI… ø ñ¡ÿÿT Õ ÕæXàªáªâª €R ?Öó ª Õ ÕhåXàª ?Öàªı{B©ôOA©öWÃ¨À_Ö( €R©  (9  €RÀ_ÖôO¾©ı{©ıC ‘óªô ªaß Õ” ”h  Ğ 	ù  ´Áß Õàª ”h  Ğ ù  ´à Õàª† ”h  Ğ ù  ´aá Õàª ”h  Ğ ù  ´â Õàªx ”h  Ğ ù  ´â Õàªq ”h  Ğ ù  ´aã Õàªj ”h  Ğ !ù  ´!ä Õàªc ”h  Ğ %ù  ´áä Õàª\ ”h  Ğ )ù  ´áå ÕàªU ”h  Ğ -ù  ´aæP ÕàªN ”h  Ğ 1ù  ´!ç ÕàªG ”h  Ğ 5ù  ´!èP Õàª@ ”h  Ğ 9ù  ´!é Õàª9 ”h  Ğ =ù  ´áéP Õàª2 ”h  Ğ Aù  ´áêP Õàª+ ”h  Ğ Eù  ´¡ë Õàª$ ”h  Ğ Iù  ´ìP Õàª ”h  Ğ Mù  ´ì Õàª ”h  Ğ Qù  ´í Õàª ”h  Ğ Uù  ´îP Õàª ”h  Ğ Yù  ´ÁîP Õàª ”h  Ğ ]ù  ´Áï Õàªú ”h  Ğ aù  ´AğP Õàªó ”h  Ğ eù  ´ñP Õàªì ”h  Ğ iù  ´ñP Õàªå ”h  Ğ mù  ´áñP ÕàªŞ ”h  Ğ qù  ´aòP Õàª× ”h  Ğ uù  ´Áò ÕàªĞ ”h  Ğ yù  ´ó ÕàªÉ ”h  Ğ }ù  ´!óP ÕàªÂ ”h  Ğ ù  ´  €R_  `Ä0 ÕZ  `Å0 ÕW   Æp ÕT  àÇp ÕQ   É0 ÕN   Êp ÕK  €Ë0 ÕH  ÀÌ0 ÕE   Î0 ÕB  `ÏP Õ?  €ĞP Õ<  àÑP Õ9  `ÓP Õ6  ÀÔP Õ3   Öp Õ0  €×P Õ-   Ø Õ*  €ÙP Õ'  ÀÚ0 Õ$   ÜP Õ!   İp Õ  €ŞP Õ  ÀßP Õ  ààp Õ   âp Õ   ã0 Õ  àãp Õ  àä Õ	   å0 Õ  `æ Õ  `çp Õ‡ğÿ—  €ı{A©ôOÂ¨À_Öø_¼©öW©ôO©ı{©ıÃ ‘óªôªõ ª  ´àªÛ ”ö ªt ´àª× ”÷ ª3 ´àªÓ ”ø ª   €Òôşÿµ €Ò3ÿÿµ €ÒÈ‹‹  ‘z ”  ´  9 ´áª± ”·  ´˜  ´áª­ ”  x  ´áª© ”ı{C©ôOB©öWA©ø_Ä¨À_Öı{¿©ı ‘Y ”   ´ @9h  4ı{Á¨¨   €Òı{Á¨À_Ö" €Rˆ º ôO¾©ı{©ıC ‘ó ª£ ” ‹ñ_8½ q   Tàª ”è€Rhj xàª™ ”h ‹ Õ ÕéİX	 ù	‹R	 r	q ¸àªP ”  ñàŸı{A©ôOÂ¨À_ÖöW½©ôO©ı{©ıƒ ‘‚R ‹¨@9 qa  T  €RË  ó ª!Ûp Õ¯ïÿ—tâ1‘  ´á ªàªm ”u ” ‹İq9½ qÀ  Tàªo ”h ‹é€R	ñyàªj ”h ‹	á1‘ Õ Õê×X
=ù‹R r(q ¸àª  ”à µÀ×P Õøïÿ—  €¥   å0 Õü ”  ´ @9È 4L ”€ ´á ªàªE ”M ” ‹İq9½ qÀ  TàªG ”h ‹é€R	ñyàªB ”h ‹	á1‘ Õ ÕêÒX
=ù‹R r(q ¸àªø ”à µàà ÕÙ ”  ´ @9È 4) ”€ ´á ªàª" ”* ” ‹İq9½ qÀ  Tàª$ ”h ‹é€R	ñyàª ”h ‹	á1‘ Õ ÕŠÎX
=ù‹R r(q ¸àªÕ ”€ µ Ü0 Õ¶ ”  ´ @9È 4 ”€ ´á ªàªÿ ” ” ‹İq9½ qÀ  Tàª ”h ‹é€R	ñyàªü ”h ‹	á1‘ Õ Õ*ÊX
=ù‹R r(q ¸àª² ”  µŸ 9è…R¨®rˆ ¹àªê ” ‹İq9½ qÀ  Tàªä ”h ‹é€R	ñyàªß ”h ‹	á1‘ Õ Õ–ÆX=ù‹R r(q ¸àª• ”€ µŸ" 9ÈÔP Õ@ùˆ ùàªÌ ” ‹İq9½ qÀ  TàªÆ ”h ‹é€R	ñyàªÁ ”h ‹	á1‘=ù‹R r(q ¸àªz ”  ´  €R( €R¨ 9ı{B©ôOA©öWÃ¨À_ÖŸ" 9ÈĞp Õ@ùˆ ùàªª ” ‹İq9½ qÀ  Tàª¤ ”h ‹é€R	ñyàªŸ ”h ‹	á1‘=ù8ÿÿüoº©úg©ø_©öW©ôO©ı{©ıC‘ÿƒÑó ª Õ¨iX@ù¨ƒøô ‘à ‘áª€€R’ ”à ‘‡ ”õ ª¨ QˆÊh8½ qà  TA»P Õà ‘"€€RÕ ”µ ‘àªA ”  ´ô ªG ”À ´¸£Ñ¹~@“µÉ Õú ‘¶óP Õ  | ”àª; ”@ ´T ‘àªáªZ ” ÿÿ4àªáªV ” şÿ4_k98à ‘áª"€€R´ ”à ‘¡£Ñ ”€ıÿ5@yà ‘@qÁüÿT¸ÿÿ—åÿÿàª¶ ”àª& ”¨ƒZø Õé`X)@ù?ë! Tÿƒ‘ı{E©ôOD©öWC©ø_B©úgA©üoÆ¨À_Ö“ ”öW½©ôO©ı{©ıƒ ‘ÿƒ"Ñóª Õh^X@ù¨ƒøà ùâÒp Õà#‘€€R ”üql Tó ùâÑp Õà# ‘€€R ”üql Tà#‘" ”ô ª!¯P Õà# ‘) ”  ´ó ª ”ˆ ‹ ‘¿úñ¨ TÔ­P Õ  àª ”¨ ‹ ‘¿úñˆ Tà#‘áª€€Ra ”à#‘áª€€R] ”  €Òáª ”@ ´ó ªà#‘¡ãÑè ”@ıÿ6à#‘8€R· ”æÿÿà#‘¡ãÑà ”  5t  °•BB¹¿ 1` TÕ 4è#‘è ù@«P Õ‡îÿ—  €Ò¨ƒ]ø ÕiTX)@ù?ë Tÿƒ"‘ı{B©ôOA©öWÃ¨À_Öà¶P Õ ”  ´ @9È 4Ñ ”€ ´ó ª!d ÕÆ ”  qõŸ•B¹àªg ”Õûÿ5  ŸB¹è#‘è ù ¨0 Õbîÿ—A©P Õà#‘O ”Øÿÿ ”öW½©ôO©ı{©ıƒ ‘ÿ@ÑÿC Ñóªõª ÕHNX@ù¨ƒø¡Ä Õ> ”ô ªàªáªoÿÿ—ó ªŸ ñ@ú Tt  ´àª$ ”Ó ´àª! ” €'  àª# ”  5àª ”@ 5à# ‘! €R ‚Rãª, ” şÿ´â ªà# ‘! €Rãª2 ”€  ´àª ”àıÿ4àª   €R   €  àªç ” €àª ”8€Rú ”àªû ”àªù ”¨ƒ]ø Õ‰FX)@ù?ë Tàªÿ@‘ÿC ‘ı{B©ôOA©öWÃ¨À_ÖÁ ”A€Rİ Ö ı{¿©ı ‘ 0 Õv ”à0 Õs ”`P Õp ” Ÿ Õm ” ŸP Õj ” Ÿ0 Õg ”  0 Õd ”  €Rı{Á¨À_ÖÿÑı{©ıÃ ‘ Õè@X@ù¨ƒø Ÿ Õë ”@ ´ @9è 4ê ”|@“è ù"p ÕàG ‘á€R" ”@ ÕáG ‘" €R ”    €R¨ƒ_ø Õ©=X)@ù?ë  Tı{C©ÿ‘À_Ö~ ” ÕÀdÀ_ÖÿÃÑø_©öW©ôO©ı{©ıƒ‘óªô ª Õ(;X@ùè ùÿ ¹àªáªp  ”–  ğ ø7¤