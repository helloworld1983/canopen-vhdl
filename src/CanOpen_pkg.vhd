library ieee;
use ieee.std_logic_1164.all;
    
package CanOpen is
    ------------------------------------------------------------
    --! TYPES
    ------------------------------------------------------------    
    type CobId is record
        FunctionCode    : std_logic_vector(3 downto 0);
        NodeId          : std_logic_vector(6 downto 0);
    end record CobId;
    
    type Sdo is record
        Cs      : std_logic_vector(2 downto 0);
        N       : std_logic_vector(1 downto 0);
        E       : std_logic;
        S       : std_logic;
        Mux     : std_logic_vector(23 downto 0);
        Data    : std_logic_vector(31 downto 0);
    end record Sdo;
    
    type NodeIdArray is array (integer range <>) of std_logic_vector(6 downto 0);
    
--    type NmtState is (
--        NMT_STATE_INITIALISATION,
--        NMT_STATE_PREOPERATIONAL,
--        NMT_STATE_OPERATIONAL,
--        NMT_STATE_STOPPED
--    );

--    ... needs this ...

--    attribute Encoding  : std_logic_vector(6 downto 0);
--    attribute Encoding of NMT_STATE_INITIALISATION[return NmtState] : literal is b"0000000";
--    attribute Encoding of NMT_STATE_PREOPERATIONAL[return NmtState] : literal is b"0000100";
--    attribute Encoding of NMT_STATE_OPERATIONAL[return NmtState]    : literal is b"0000101";
--    attribute Encoding of NMT_STATE_STOPPED[return NmtState]        : literal is b"1111111";

--    NmtStateValue <= NodeNmtState'Encoding; --! Usage

--    ... or this ...

--    type NmtStateLookup is array(NmtState) of std_logic_vector(6 downto 0);

--    constant NMT_STATE_LOOKUP   : NmtStateLookup := (
--        NMT_STATE_INITIALISATION    => b"0000000",
--        NMT_STATE_STOPPED           => b"0000100",
--        NMT_STATE_OPERATIONAL       => b"0000101",
--        NMT_STATE_PREOPERATIONAL    => b"1111111"
--    );

--    NmtStateValue <= NMT_STATE_LOOKUP(NodeNmtState); --! Usage

    ------------------------------------------------------------
    --! CONSTANTS
    ------------------------------------------------------------
    --! CANopen function codes per CiA 301
    constant FUNCTION_CODE_NMT                      : std_logic_vector(3 downto 0);
    constant FUNCTION_CODE_SYNC                     : std_logic_vector(3 downto 0);
    constant FUNCTION_CODE_TPDO1                    : std_logic_vector(3 downto 0);
    constant FUNCTION_CODE_RPDO1                    : std_logic_vector(3 downto 0);
    constant FUNCTION_CODE_TPDO2                    : std_logic_vector(3 downto 0);
    constant FUNCTION_CODE_RPDO2                    : std_logic_vector(3 downto 0);
    constant FUNCTION_CODE_TPDO3                    : std_logic_vector(3 downto 0);
    constant FUNCTION_CODE_RPDO3                    : std_logic_vector(3 downto 0);
    constant FUNCTION_CODE_TPDO4                    : std_logic_vector(3 downto 0);
    constant FUNCTION_CODE_RPDO4                    : std_logic_vector(3 downto 0);
    constant FUNCTION_CODE_SDO_TX                   : std_logic_vector(3 downto 0);
    constant FUNCTION_CODE_SDO_RX                   : std_logic_vector(3 downto 0);
    constant FUNCTION_CODE_NMT_ERROR_CONTROL        : std_logic_vector(3 downto 0);
    
    constant BROADCAST_NODE_ID          : std_logic_vector(6 downto 0);
        
    --! CANopen NMT commands per CiA 301
    constant NMT_NODE_CONTROL           : std_logic_vector(6 downto 0);
    constant NMT_GFC                    : std_logic_vector(6 downto 0);
    
    --! CANopen NMT node control commands per CiA 301
    constant NMT_NODE_CONTROL_OPERATIONAL       : std_logic_vector(7 downto 0);
    constant NMT_NODE_CONTROL_STOPPED           : std_logic_vector(7 downto 0);
    constant NMT_NODE_CONTROL_PREOPERATIONAL    : std_logic_vector(7 downto 0);
    constant NMT_NODE_CONTROL_RESET_APP         : std_logic_vector(7 downto 0);
    constant NMT_NODE_CONTROL_RESET_COMM        : std_logic_vector(7 downto 0);
    
    --! CANopen NMT states per CiA 301
    constant NMT_STATE_INITIALISATION   : std_logic_vector(6 downto 0);
    constant NMT_STATE_STOPPED          : std_logic_vector(6 downto 0);
    constant NMT_STATE_OPERATIONAL      : std_logic_vector(6 downto 0);
    constant NMT_STATE_PREOPERATIONAL   : std_logic_vector(6 downto 0);
    
    --! CANopen SDO Command Specifiers per CiA 301
    constant SDO_CS_ABORT               : std_logic_vector(2 downto 0); --! Abort transfer
    
    --! CANopen SDO Client Command Specifiers (CCSs) per CiA 301
    constant SDO_CCS_DSR                : std_logic_vector(2 downto 0); --! Download segment request
    constant SDO_CCS_IDR                : std_logic_vector(2 downto 0); --! Initiate download request
    constant SDO_CCS_IUR                : std_logic_vector(2 downto 0); --! Intiate upload request
    constant SDO_CCS_USR                : std_logic_vector(2 downto 0); --! Upload segment request
    constant SDO_CCS_BUR                : std_logic_vector(2 downto 0); --! Block upload request
    constant SDO_CCS_BDR                : std_logic_vector(2 downto 0); --! Block download request
    
    --! CANopen SDO Server Command Specifiers (SCSs) per CiA 301
    constant SDO_SCS_USR                : std_logic_vector(2 downto 0); --! Upload segment response
    constant SDO_SCS_DSR                : std_logic_vector(2 downto 0); --! Download segment response
    constant SDO_SCS_IUR                : std_logic_vector(2 downto 0); --! Initiate upload response
    constant SDO_SCS_IDR                : std_logic_vector(2 downto 0); --! Initiate download response
    constant SDO_SCS_BDR                : std_logic_vector(2 downto 0); --! Block download response
    constant SDO_SCS_BUR                : std_logic_vector(2 downto 0); --! Block upload response
    
    --! CANopen SDO abort codes per CiA 301
    constant SDO_ABORT_CS               : std_logic_vector(31 downto 0); --! Client/server command specifier not valid or unknown
    constant SDO_ABORT_WO               : std_logic_vector(31 downto 0); --! Attempt to read a write only object
    constant SDO_ABORT_RO               : std_logic_vector(31 downto 0); --! Attempt to write a read only object
    constant SDO_ABORT_DNE              : std_logic_vector(31 downto 0); --! Object does not exist in the object dictionary
    constant SDO_ABORT_PARAM_LONG       : std_logic_vector(31 downto 0); --! Data type does not match, length of service parameter too high
    constant SDO_ABORT_PARAM_SHORT      : std_logic_vector(31 downto 0); --! Data type does not match, length of service parameter too low
    constant SDO_ABORT_PARAM_INVALID    : std_logic_vector(31 downto 0); --! Invalid value for parameter (download only)
    constant SDO_ABORT_PARAM_HIGH       : std_logic_vector(31 downto 0); --! Value of parameter written too high (download only)
    constant SDO_ABORT_PARAM_LOW        : std_logic_vector(31 downto 0); --! Value of parameter written too low (download only)
    
    --! CANopen Object Dictionary (OD)
    --! Mandatory indices per CiA 301
    constant ODI_DEVICE_TYPE            : std_logic_vector(23 downto 0);
    constant ODI_SYNC                   : std_logic_vector(23 downto 0);
    constant ODI_ERROR                  : std_logic_vector(23 downto 0);
    constant ODI_ID_LENGTH              : std_logic_vector(23 downto 0);
    constant ODI_ID_VENDOR              : std_logic_vector(23 downto 0);
    constant ODI_ID_PRODUCT             : std_logic_vector(23 downto 0);
    constant ODI_ID_REVISION            : std_logic_vector(23 downto 0);
    constant ODI_ID_SERIAL              : std_logic_vector(23 downto 0);
    constant ODI_VERSION_COUNT          : std_logic_vector(23 downto 0);
    constant ODI_VERSION_1              : std_logic_vector(23 downto 0);
    constant ODI_VERSION_2              : std_logic_vector(23 downto 0);
    --! Conditional indices per CiA 301
    constant ODI_HEARTBEAT_CONSUMER_TIME : std_logic_vector(23 downto 0); --! If Heartbeat consumer
    constant ODI_HEARTBEAT_PRODUCER_TIME : std_logic_vector(23 downto 0); --! If Heartbeat Protocol
    constant ODI_SYNC_COUNTER_OVERFLOW  : std_logic_vector(23 downto 0); --! If synchronous counter
    constant ODI_ERROR_BEHAVIOR         : std_logic_vector(23 downto 0);
    constant ODI_SDO_SERVER_COUNT       : std_logic_vector(23 downto 0); --! If SDO
    constant ODI_SDO_SERVER_RX_ID       : std_logic_vector(23 downto 0); --! CAN ID used for SDO client-to-server
    constant ODI_SDO_SERVER_TX_ID       : std_logic_vector(23 downto 0); --! CAN ID used for SDO server-to-client
    constant ODI_TPDO1_COMM_COUNT       : std_logic_vector(23 downto 0); --! If PDO1 TX
    constant ODI_TPDO1_COMM_ID          : std_logic_vector(23 downto 0); --! CAN ID used for TPDO1 (0x180 + Address)
    constant ODI_TPDO1_COMM_TYPE        : std_logic_vector(23 downto 0); --! Transmission (trigger) type for TPDO1
    constant ODI_TPDO2_COMM_COUNT       : std_logic_vector(23 downto 0); --! If PDO2 TX
    constant ODI_TPDO2_COMM_ID          : std_logic_vector(23 downto 0); --! CAN ID used for TPDO2 (0x181 + Address)
    constant ODI_TPDO2_COMM_TYPE        : std_logic_vector(23 downto 0); --! Transmission (trigger) type for TPDO2
    constant ODI_TPDO3_COMM_COUNT       : std_logic_vector(23 downto 0); --! If PDO3 TX
    constant ODI_TPDO3_COMM_ID          : std_logic_vector(23 downto 0); --! CAN ID used for TPDO3 (0x182 + Address)
    constant ODI_TPDO3_COMM_TYPE        : std_logic_vector(23 downto 0); --! Transmission (trigger) type for TPDO3
    constant ODI_TPDO4_COMM_COUNT       : std_logic_vector(23 downto 0); --! If PDO4 TX
    constant ODI_TPDO4_COMM_ID          : std_logic_vector(23 downto 0); --! CAN ID used for TPDO4 (0x183 + Address)
    constant ODI_TPDO4_COMM_TYPE        : std_logic_vector(23 downto 0); --! Transmission (trigger) type for TPDO4
    constant ODI_TPDO1_MAPPING          : std_logic_vector(23 downto 0);
    constant ODI_TPDO2_MAPPING          : std_logic_vector(23 downto 0);
    constant ODI_TPDO3_MAPPING          : std_logic_vector(23 downto 0);
    constant ODI_TPDO4_MAPPING          : std_logic_vector(23 downto 0);
    constant ODI_NMT_STARTUP            : std_logic_vector(23 downto 0);
    
    --! CANopen Device Profiles
    constant DEVICE_PROFILE_GENERIC_IO      : std_logic_vector(15 downto 0);
end package CanOpen;

package body CanOpen is
    --! CANopen function codes per CiA 301
    constant FUNCTION_CODE_NMT                      : std_logic_vector(3 downto 0) := b"0000";
    constant FUNCTION_CODE_SYNC                     : std_logic_vector(3 downto 0) := b"0001";
    constant FUNCTION_CODE_TPDO1                    : std_logic_vector(3 downto 0) := b"0011";
    constant FUNCTION_CODE_RPDO1                    : std_logic_vector(3 downto 0) := b"0100";
    constant FUNCTION_CODE_TPDO2                    : std_logic_vector(3 downto 0) := b"0101";
    constant FUNCTION_CODE_RPDO2                    : std_logic_vector(3 downto 0) := b"0110";
    constant FUNCTION_CODE_TPDO3                    : std_logic_vector(3 downto 0) := b"0111";
    constant FUNCTION_CODE_RPDO3                    : std_logic_vector(3 downto 0) := b"1000";
    constant FUNCTION_CODE_TPDO4                    : std_logic_vector(3 downto 0) := b"1001";
    constant FUNCTION_CODE_RPDO4                    : std_logic_vector(3 downto 0) := b"1010";
    constant FUNCTION_CODE_SDO_TX                   : std_logic_vector(3 downto 0) := b"1011";
    constant FUNCTION_CODE_SDO_RX                   : std_logic_vector(3 downto 0) := b"1100";
    constant FUNCTION_CODE_NMT_ERROR_CONTROL        : std_logic_vector(3 downto 0) := b"1110";
    
    constant BROADCAST_NODE_ID          : std_logic_vector(6 downto 0) := (others => '0');
    
    --! CANopen NMT commands per CiA 301
    constant NMT_NODE_CONTROL           : std_logic_vector(6 downto 0) := b"0000000";
    constant NMT_GFC                    : std_logic_vector(6 downto 0) := b"0000001";
    
    --! CANopen NMT node control commands
    constant NMT_NODE_CONTROL_OPERATIONAL       : std_logic_vector(7 downto 0) := x"01";
    constant NMT_NODE_CONTROL_STOPPED           : std_logic_vector(7 downto 0) := x"02";
    constant NMT_NODE_CONTROL_PREOPERATIONAL    : std_logic_vector(7 downto 0) := x"80";
    constant NMT_NODE_CONTROL_RESET_APP         : std_logic_vector(7 downto 0) := x"81";
    constant NMT_NODE_CONTROL_RESET_COMM        : std_logic_vector(7 downto 0) := x"82";
    
    --! CANopen NMT states per CiA 301
    constant NMT_STATE_INITIALISATION   : std_logic_vector(6 downto 0) := b"0000000";
    constant NMT_STATE_STOPPED          : std_logic_vector(6 downto 0) := b"0000100";
    constant NMT_STATE_OPERATIONAL      : std_logic_vector(6 downto 0) := b"0000101";
    constant NMT_STATE_PREOPERATIONAL   : std_logic_vector(6 downto 0) := b"1111111";
    
    --! CANopen SDO Command Specifiers per CiA 301
    constant SDO_CS_ABORT               : std_logic_vector(2 downto 0) := b"100"; --! Abort transfer
    
    --! CANopen SDO Client Command Specifiers (CCSs) per CiA 301
    constant SDO_CCS_DSR                : std_logic_vector(2 downto 0) := b"000"; --! Download segment request
    constant SDO_CCS_IDR                : std_logic_vector(2 downto 0) := b"001"; --! Initiate download request
    constant SDO_CCS_IUR                : std_logic_vector(2 downto 0) := b"010"; --! Intiate upload request
    constant SDO_CCS_USR                : std_logic_vector(2 downto 0) := b"011"; --! Upload segment request
    constant SDO_CCS_BUR                : std_logic_vector(2 downto 0) := b"101"; --! Block upload request
    constant SDO_CCS_BDR                : std_logic_vector(2 downto 0) := b"110"; --! Block download request
    
    --! CANopen SDO Server Command Specifiers (SCSs) per CiA 301
    constant SDO_SCS_USR                : std_logic_vector(2 downto 0) := b"000"; --! Upload segment response
    constant SDO_SCS_DSR                : std_logic_vector(2 downto 0) := b"001"; --! Download segment response
    constant SDO_SCS_IUR                : std_logic_vector(2 downto 0) := b"010"; --! Initiate upload response
    constant SDO_SCS_IDR                : std_logic_vector(2 downto 0) := b"011"; --! Initiate download response
    constant SDO_SCS_BDR                : std_logic_vector(2 downto 0) := b"101"; --! Block download response
    constant SDO_SCS_BUR                : std_logic_vector(2 downto 0) := b"110"; --! Block upload response
      
    --! CANopen SDO abort codes per CiA 301
    constant SDO_ABORT_CS               : std_logic_vector(31 downto 0) := x"05040001"; --! Client/server command specifier not valid or unknown
    constant SDO_ABORT_ACCESS           : std_logic_vector(31 downto 0) := x"06010000"; --! Unsupported access to an object
    constant SDO_ABORT_WO               : std_logic_vector(31 downto 0) := x"06010001"; --! Attempt to read a write only object
    constant SDO_ABORT_RO               : std_logic_vector(31 downto 0) := x"06010002"; --! Attempt to write a read only object
    constant SDO_ABORT_DNE              : std_logic_vector(31 downto 0) := x"06020000"; --! Object does not exist in the object dictionary
    constant SDO_ABORT_PARAM            : std_logic_vector(31 downto 0) := x"06070010"; --! Data type does not match, length of service parameter does not match
    constant SDO_ABORT_PARAM_LONG       : std_logic_vector(31 downto 0) := x"06070012"; --! Data type does not match, length of service parameter too high
    constant SDO_ABORT_PARAM_SHORT      : std_logic_vector(31 downto 0) := x"06070013"; --! Data type does not match, length of service parameter too low
    constant SDO_ABORT_PARAM_INVALID    : std_logic_vector(31 downto 0) := x"06090030"; --! Invalid value for parameter (download only)
    constant SDO_ABORT_PARAM_HIGH       : std_logic_vector(31 downto 0) := x"06090031"; --! Value of parameter written too high (download only)
    constant SDO_ABORT_PARAM_LOW        : std_logic_vector(31 downto 0) := x"06090032"; --! Value of parameter written too low (download only)
    
    --! CANopen Object Dictionary indices (ODIs) 
    --! Mandatory indices per CiA 301
    constant ODI_DEVICE_TYPE            : std_logic_vector(23 downto 0) := x"100000";
    constant ODI_ERROR                  : std_logic_vector(23 downto 0) := x"100100";
    constant ODI_SYNC                   : std_logic_vector(23 downto 0) := x"100500";
    constant ODI_ID_LENGTH              : std_logic_vector(23 downto 0) := x"101800";
    constant ODI_ID_VENDOR              : std_logic_vector(23 downto 0) := x"101801";
    constant ODI_ID_PRODUCT             : std_logic_vector(23 downto 0) := x"101802";
    constant ODI_ID_REVISION            : std_logic_vector(23 downto 0) := x"101803";
    constant ODI_ID_SERIAL              : std_logic_vector(23 downto 0) := x"101804";
    constant ODI_VERSION_COUNT          : std_logic_vector(23 downto 0) := x"103000";
    constant ODI_VERSION_1              : std_logic_vector(23 downto 0) := x"103001";
    constant ODI_VERSION_2              : std_logic_vector(23 downto 0) := x"103002";
    --! Conditional indices (based on supported features) per CiA 301
    constant ODI_HEARTBEAT_CONSUMER_TIME : std_logic_vector(23 downto 0) := x"101600"; --! If Heartbeat consumer
    constant ODI_HEARTBEAT_PRODUCER_TIME : std_logic_vector(23 downto 0) := x"101700"; --! If Heartbeat Protocol
    constant ODI_SYNC_COUNTER_OVERFLOW  : std_logic_vector(23 downto 0) := x"101900"; --! If synchronous counter
    constant ODI_ERROR_BEHAVIOR         : std_logic_vector(23 downto 0) := x"102900";
    constant ODI_SDO_SERVER_COUNT       : std_logic_vector(23 downto 0) := x"120000"; --! If SDO
    constant ODI_SDO_SERVER_RX_ID       : std_logic_vector(23 downto 0) := x"120001"; --! CAN ID used for SDO client-to-server
    constant ODI_SDO_SERVER_TX_ID       : std_logic_vector(23 downto 0) := x"120002"; --! CAN ID used for SDO server-to-client
    constant ODI_TPDO1_COMM_COUNT       : std_logic_vector(23 downto 0) := x"180000"; --! If PDO1 TX
    constant ODI_TPDO1_COMM_ID          : std_logic_vector(23 downto 0) := x"180001"; --! CAN ID used for TPDO1 (0x180 + Address)
    constant ODI_TPDO1_COMM_TYPE        : std_logic_vector(23 downto 0) := x"180002"; --! Transmission (trigger) type for TPDO1
    constant ODI_TPDO2_COMM_COUNT       : std_logic_vector(23 downto 0) := x"180100"; --! If PDO2 TX
    constant ODI_TPDO2_COMM_ID          : std_logic_vector(23 downto 0) := x"180101"; --! CAN ID used for TPDO2 (0x181 + Address)
    constant ODI_TPDO2_COMM_TYPE        : std_logic_vector(23 downto 0) := x"180102"; --! Transmission (trigger) type for TPDO2
    constant ODI_TPDO3_COMM_COUNT       : std_logic_vector(23 downto 0) := x"180200"; --! If PDO3 TX
    constant ODI_TPDO3_COMM_ID          : std_logic_vector(23 downto 0) := x"180201"; --! CAN ID used for TPDO3 (0x182 + Address)
    constant ODI_TPDO3_COMM_TYPE        : std_logic_vector(23 downto 0) := x"180202"; --! Transmission (trigger) type for TPDO3
    constant ODI_TPDO4_COMM_COUNT       : std_logic_vector(23 downto 0) := x"180300"; --! If PDO4 TX
    constant ODI_TPDO4_COMM_ID          : std_logic_vector(23 downto 0) := x"180301"; --! CAN ID used for TPDO4 (0x183 + Address)
    constant ODI_TPDO4_COMM_TYPE        : std_logic_vector(23 downto 0) := x"180302"; --! Transmission (trigger) type for TPDO4
    constant ODI_TPDO1_MAPPING          : std_logic_vector(23 downto 0) := x"1A0000";
    constant ODI_TPDO2_MAPPING          : std_logic_vector(23 downto 0) := x"1A0100";
    constant ODI_TPDO3_MAPPING          : std_logic_vector(23 downto 0) := x"1A0200";
    constant ODI_TPDO4_MAPPING          : std_logic_vector(23 downto 0) := x"1A0300";
    constant ODI_NMT_STARTUP            : std_logic_vector(23 downto 0) := x"1F8000";
    
    --! CANopen Device Profiles
    constant DEVICE_PROFILE_GENERIC_IO      : std_logic_vector(15 downto 0) := x"0191";
end package body CanOpen;