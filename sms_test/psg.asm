        public  _PSGInit
        public  _PSGFrame
        public  _PSGPlay
        public  _music

        section code_user

        include "PSGlib.inc"

        section rodata_user
_music:
        binary  "my_mission.psg"
