000100110720      * ------------------------------------------------------------------------------
000200110720      *  Copyright 2009 Ronnie Dlomo
000300110720      *
000400110720      *  Licensed under the Apache License, Version 2.0 (the "License");
000500110720      *  you may not use this file except in compliance with the License.
000600110720      *  You may obtain a copy of the License at
000700110720      *
000800110720      *      http://www.apache.org/licenses/LICENSE-2.0
000900110720      *
001000110720      *  Unless required by applicable law or agreed to in writing, software
001100110720      *  distributed under the License is distributed on an "AS IS" BASIS,
001200110720      *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
001300110720      *  See the License for the specific language governing permissions and
001400110720      *  limitations under the License.
001500110720      * ------------------------------------------------------------------------------
001600110720      /if not defined (RPGLET)
001700110720      /define RPGLET
001800110718     DRPGLET_setContentType...
001900110718     D                 PR                  extProc('RPGLET_setContentType')
002000110718     D @value                     32000a   const varying
002100110718
002200110718     DRPGLET_printString...
002300110718     D                 PR                  extProc('RPGLET_printString')
002400110718     D @value                     32000a   value
002500110720
002600110719      /endif
002700110720
002800110720      /if defined (SERVER_RPGLET)
002900110720
003000110720     DRPGLET_setOutputStream...
003100110720     D                 PR                  extProc('RPGLET_setOutputStream')
003200110720     D @buffer                         *
003300110720
003400110720     DRPGLET_propertiesFromString...
003500110720     D                 PR              *   extProc(
003600110720     D                                     'RPGLET_propertiesFromString')
003700110720     D @buffer                         *   const
003800110720     D
003900110720
004000110720     DRPGLET_propertiestoString...
004100110720     D                 PR              *   extProc('RPGLET_propertiesToString')
004200110720     D                                 *   const
004300110720
004400110720     DRPGLET_setConfig...
004500110720     D                 PR                  extproc('RPGLET_setConfig')
004600110720     D @config                         *
004700110720
004800110720      /endif
