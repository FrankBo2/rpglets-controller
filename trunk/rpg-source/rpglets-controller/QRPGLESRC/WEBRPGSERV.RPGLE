000100110719      * ------------------------------------------------------------------------------
000200110719      *  Copyright 2009 Ronnie Dlomo
000300110719      *
000400110719      *  Licensed under the Apache License, Version 2.0 (the "License");
000500110719      *  you may not use this file except in compliance with the License.
000600110719      *  You may obtain a copy of the License at
000700110719      *
000800110719      *      http://www.apache.org/licenses/LICENSE-2.0
000900110719      *
001000110719      *  Unless required by applicable law or agreed to in writing, software
001100110719      *  distributed under the License is distributed on an "AS IS" BASIS,
001200110719      *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
001300110719      *  See the License for the specific language governing permissions and
001400110719      *  limitations under the License.
001500110719      * ------------------------------------------------------------------------------
001600110720     HBndDir('WEBTOOLS': 'RPGSERVE')
001700070703
001800110718     Dmain             PR                  EXTPGM('RDGATE')
001900110718     D                                1a   options(*varsize)
002000110718     D                                1a   options(*varsize)
002100110718     D                                1a   options(*varsize)
002200070704
002300110718     Dmain             PI
002400110718     D  pInput                        1a   options(*varsize)
002500110718     D  pOutput                       1a   options(*varsize)
002600110718     D  pConfig                       1a   options(*varsize)
002700110720
002800110720      /define SERVER_RPGLET
002900070704
003000110717     d/copy arraylisth
003100110718     d/copy SYSPSDS
003200110720     D/copy WEBRPG_H
003300110719
003400110720      /include /home/ronnie/includes/libc_h.rpgle
003500110720      /include /home/ronnie/properties/properties_h.rpgle
003600110719      /include /home/ronnie/arraylist/arraylist_h.rpgle
003700070703
003800110717     DfromString       PR              *
003900110717     D buffer                          *      const
004000070703
004100110717     d input_properties...
004200110717     d                 s               *
004300110717     d output_properties...
004400110717     d                 s               *
004500110717     d config_properties...
004600110717     d                 s               *
004700110717
004800110717     DRPGevlet         PR                  ExtPgm(request)
004900110717     D  pInput                         *
005000110717     D  pOutput                        *
005100110717     D  pConfig                        *
005200110717
005300110717     d pgm             s             10a   Inz('Error_Pgm')
005400110717
005500110719     d @config         s               *
005600110719     d @output         s               *
005700110719     d @input          s               *
005800110719
005900110719     d @properties     s               *
006000110717
006100110717     d HANDLER         c                         'REQUEST'
006200110717     d request         s             10a
006300110719
006400030812      /free
006500110719       @config  =  %ADDR( pConfig ) ;
006600110719       @output  =  %ADDR( pOutput ) ;
006700110719       @input   =  %ADDR( pInput  ) ;
006800110719
006900110719       // deserialize  parameters
007000110719       input_properties =  RPGLET_propertiesFromString( @input  );
007100110719       config_properties = RPGLET_propertiesFromString( @config );
007200110718
007300110719       // Authantication Manager - Create Access control
007400110719       Monitor;
007500110719           request = 'RDGATEKEEP';
007600110719           RpgevLet( input_properties: @output : config_properties);
007700110719       on-Error;
007800110719           //
007900110719       endmon;
008000110719
008100110719        // use  RPGLET_printString to append data to the output
008200110718        @output = %addr(pOutput);
008300110719        RPGLET_setConfig(config_properties);
008400110719        RPGLET_setOutputStream( @output );
008500110717
008600110717        if ( properties_contains(input_properties: HANDLER) );
008700110717           request = properties_get(input_properties : HANDLER );
008800110718           RPGLET_setConfig(config_properties);
008900110717           Monitor;
009000110717               RpgevLet( input_properties: @output : config_properties);
009100110718               properties_put(config_properties: 'STATUS': 'SUCCESS');
009200110717           On-Error;
009300110721              properties_put(config_properties: 'STATUS': 'FAIL');
009400110718              ExSR errorStatus;
009500110717           EndMon;
009600110717        Else;
009700110721              properties_put(config_properties: 'MESSAGE':
009800110721                            'No Target RPGLET Specified in the Request');
009900110721              ExSR errorStatus;
010000110717        EndIf;
010100110719
010200110719        // update serialized config attributes
010300110721        ExSr  refreshCongig;
010400110721        //@properties  =  RPGLET_propertiesToString(config_properties);
010500110721        //memcpy(%Addr(pConfig) : @properties : %len(%str(@properties)) );
010600110717
010700110717        *INLR = *On;
010800070703        return;
010900110719        // * ========================================================= * //
011000110721        //      Experimental Will change into sub procs just lazy
011100110719        // * ========================================================= * //
011200110721        BegSr refreshCongig;
011300110721         // update serialized config attributes
011400110721         @properties  =  RPGLET_propertiesToString(config_properties);
011500110721         memcpy(%Addr(pConfig) : @properties : %len(%str(@properties)) );
011600110721        EndSr;
011700110721
011800070704        BegSr *pssr;
011900110718          *INLR = *On;
012000110721          properties_put(config_properties: 'STATUS': 'FAIL');
012100110718          ExSr errorStatus;
012200110718          Return;
012300070704        EndSr;
012400110719
012500110718        BegSr errorStatus;
012600110718          monitor;
012700110721             properties_put(config_properties: 'STATE' : MYPSDS );
012800110718          on-error;
012900110718          EndMon;
013000110718        EndSr;
013100070703      /End-free
