# Guidelines

BG-IW isn't only an educational project, is an opportunity to get used to applying best practices. So, if you want to help us build an awesome project that will help onboard people in an interactive way, please follow the guidelines below.

## Imports
Always use named imports. Example:
```
import {ContractName} from "path/File.sol";
```

## Errors

Always starts the event name with ContractName__VerboseErrorName();

## Events

Always starts the event name with ContractName__VerboseEventName();

## CEI

Follow the Checks, Effects, and Interaction pattern.

## Variables
If not immutable or constant, variables must be private. Create get functions if you need to access them externally.

**immutables** - i_variable
**constant** - VARIABLE_NAME
**private** - s_variableName

## Storages

Always use s_name for storage.

## Functions

Be precise. Ask yourself if a function can't have a more restricted visibility, if not, ok!

## Contract Layout

<details>
<summary>Copy&Paste</summary>
    ///version///

    ///imports///

    ///errors///

    ///interfaces, libraries///

    contract ContractName{

    ///Type declarations///

    ///State variables///

    ///Events///

    ///Modifiers///

    ///Functions///

    ### Layout of Functions:
    ///constructor///

    ///receive function (if exists)///

    ///fallback function (if exists)///

    ///external///

    ///public///

    ///internal///

    ///private///

    ///view & pure functions///
    }
<details>
