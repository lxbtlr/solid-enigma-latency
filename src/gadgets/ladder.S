.global gadget_start
gadget_start:
    .align 64
    .global rail_1
    .global rail_2

// NOTE: ICACHE LADDER
// This microbenchmark implements a pingpong latency test between two threads
// Thread 1 starts at rail_1, Thread 2 enters at gadget_entry
//RAIL 1
rail_1:
rail_1_0:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_0(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_1:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_1(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_2:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_2(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_3:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_3(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_4:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_4(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_5:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_5(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_6:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_6(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_7:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_7(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_8:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_8(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_9:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_9(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_10:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_10(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_11:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_11(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_12:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_12(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_13:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_13(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_14:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_14(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_15:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_15(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_16:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_16(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_17:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_17(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_18:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_18(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_19:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_19(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_20:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_20(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_21:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_21(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_22:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_22(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_23:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_23(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_24:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_24(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_25:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_25(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_26:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_26(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_27:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_27(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_28:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_28(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_29:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_29(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_30:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_30(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_31:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_31(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_32:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_32(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_33:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_33(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_34:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_34(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_35:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_35(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_36:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_36(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_37:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_37(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_38:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_38(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_39:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_39(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_40:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_40(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_41:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_41(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_42:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_42(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_43:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_43(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_44:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_44(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_45:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_45(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_46:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_46(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_47:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_47(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_48:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_48(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_49:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_49(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_50:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_50(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_51:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_51(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_52:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_52(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_53:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_53(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_54:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_54(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_55:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_55(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_56:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_56(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_57:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_57(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_58:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_58(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_59:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_59(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_60:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_60(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_61:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_61(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_62:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_62(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_63:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_63(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_64:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_64(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_65:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_65(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_66:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_66(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_67:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_67(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_68:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_68(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_69:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_69(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_70:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_70(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_71:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_71(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_72:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_72(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_73:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_73(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_74:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_74(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_75:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_75(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_76:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_76(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_77:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_77(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_78:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_78(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_79:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_79(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_80:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_80(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_81:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_81(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_82:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_82(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_83:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_83(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_84:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_84(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_85:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_85(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_86:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_86(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_87:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_87(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_88:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_88(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_89:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_89(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_90:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_90(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_91:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_91(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_92:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_92(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_93:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_93(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_94:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_94(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_95:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_95(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_96:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_96(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_97:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_97(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_98:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_98(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_99:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_99(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_100:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_100(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_101:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_101(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_102:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_102(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_103:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_103(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_104:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_104(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_105:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_105(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_106:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_106(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_107:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_107(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_108:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_108(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_109:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_109(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_110:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_110(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_111:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_111(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_112:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_112(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_113:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_113(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_114:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_114(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_115:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_115(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_116:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_116(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_117:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_117(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_118:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_118(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_119:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_119(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_120:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_120(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_121:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_121(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_122:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_122(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_123:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_123(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_124:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_124(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_125:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_125(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_126:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_126(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_127:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_127(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_128:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_128(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_129:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_129(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_130:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_130(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_131:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_131(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_132:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_132(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_133:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_133(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_134:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_134(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_135:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_135(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_136:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_136(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_137:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_137(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_138:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_138(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_139:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_139(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_140:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_140(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_141:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_141(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_142:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_142(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_143:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_143(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_144:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_144(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_145:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_145(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_146:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_146(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_147:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_147(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_148:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_148(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_149:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_149(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_150:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_150(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_151:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_151(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_152:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_152(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_153:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_153(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_154:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_154(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_155:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_155(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_156:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_156(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_157:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_157(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_158:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_158(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_159:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_159(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_160:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_160(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_161:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_161(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_162:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_162(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_163:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_163(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_164:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_164(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_165:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_165(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_166:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_166(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_167:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_167(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_168:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_168(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_169:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_169(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_170:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_170(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_171:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_171(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_172:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_172(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_173:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_173(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_174:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_174(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_175:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_175(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_176:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_176(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_177:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_177(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_178:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_178(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_179:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_179(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_180:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_180(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_181:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_181(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_182:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_182(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_183:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_183(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_184:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_184(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_185:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_185(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_186:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_186(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_187:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_187(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_188:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_188(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_189:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_189(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_190:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_190(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_191:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_191(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_192:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_192(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_193:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_193(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_194:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_194(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_195:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_195(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_196:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_196(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_197:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_197(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_198:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_198(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_199:
    jmp .                           // Jump in place (wait for rail_2 to unblock)
    MOVW $0x00eb,rail_2_199(%rip)   # Stop rail_2 from jumping in place (unblock rail_2)
rail_1_bottom:
    jmp footer

.global gadget_entry
gadget_entry:
    MOVW $0x00eb,rail_1_0(%rip)     # Stop rail_1 from jumping in place (start the pingpong)

//RAIL 2  
rail_2:
rail_2_0:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_1(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_1:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_2(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_2:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_3(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_3:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_4(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_4:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_5(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_5:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_6(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_6:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_7(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_7:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_8(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_8:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_9(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_9:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_10(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_10:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_11(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_11:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_12(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_12:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_13(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_13:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_14(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_14:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_15(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_15:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_16(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_16:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_17(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_17:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_18(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_18:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_19(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_19:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_20(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_20:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_21(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_21:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_22(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_22:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_23(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_23:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_24(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_24:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_25(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_25:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_26(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_26:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_27(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_27:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_28(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_28:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_29(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_29:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_30(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_30:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_31(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_31:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_32(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_32:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_33(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_33:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_34(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_34:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_35(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_35:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_36(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_36:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_37(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_37:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_38(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_38:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_39(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_39:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_40(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_40:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_41(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_41:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_42(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_42:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_43(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_43:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_44(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_44:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_45(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_45:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_46(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_46:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_47(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_47:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_48(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_48:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_49(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_49:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_50(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_50:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_51(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_51:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_52(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_52:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_53(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_53:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_54(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_54:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_55(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_55:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_56(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_56:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_57(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_57:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_58(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_58:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_59(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_59:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_60(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_60:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_61(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_61:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_62(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_62:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_63(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_63:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_64(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_64:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_65(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_65:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_66(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_66:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_67(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_67:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_68(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_68:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_69(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_69:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_70(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_70:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_71(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_71:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_72(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_72:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_73(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_73:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_74(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_74:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_75(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_75:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_76(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_76:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_77(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_77:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_78(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_78:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_79(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_79:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_80(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_80:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_81(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_81:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_82(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_82:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_83(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_83:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_84(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_84:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_85(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_85:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_86(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_86:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_87(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_87:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_88(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_88:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_89(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_89:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_90(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_90:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_91(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_91:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_92(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_92:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_93(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_93:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_94(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_94:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_95(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_95:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_96(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_96:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_97(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_97:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_98(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_98:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_99(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_99:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_100(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_100:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_101(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_101:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_102(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_102:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_103(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_103:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_104(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_104:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_105(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_105:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_106(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_106:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_107(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_107:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_108(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_108:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_109(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_109:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_110(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_110:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_111(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_111:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_112(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_112:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_113(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_113:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_114(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_114:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_115(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_115:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_116(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_116:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_117(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_117:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_118(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_118:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_119(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_119:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_120(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_120:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_121(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_121:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_122(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_122:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_123(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_123:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_124(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_124:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_125(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_125:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_126(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_126:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_127(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_127:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_128(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_128:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_129(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_129:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_130(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_130:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_131(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_131:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_132(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_132:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_133(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_133:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_134(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_134:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_135(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_135:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_136(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_136:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_137(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_137:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_138(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_138:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_139(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_139:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_140(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_140:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_141(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_141:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_142(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_142:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_143(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_143:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_144(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_144:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_145(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_145:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_146(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_146:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_147(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_147:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_148(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_148:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_149(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_149:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_150(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_150:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_151(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_151:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_152(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_152:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_153(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_153:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_154(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_154:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_155(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_155:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_156(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_156:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_157(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_157:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_158(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_158:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_159(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_159:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_160(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_160:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_161(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_161:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_162(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_162:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_163(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_163:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_164(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_164:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_165(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_165:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_166(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_166:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_167(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_167:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_168(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_168:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_169(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_169:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_170(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_170:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_171(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_171:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_172(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_172:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_173(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_173:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_174(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_174:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_175(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_175:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_176(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_176:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_177(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_177:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_178(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_178:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_179(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_179:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_180(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_180:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_181(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_181:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_182(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_182:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_183(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_183:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_184(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_184:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_185(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_185:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_186(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_186:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_187(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_187:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_188(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_188:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_189(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_189:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_190(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_190:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_191(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_191:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_192(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_192:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_193(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_193:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_194(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_194:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_195(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_195:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_196(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_196:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_197(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_197:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_198(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_198:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_199(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_199:
    jmp .                           // Jump in place (wait for rail_1 to unblock)
    MOVW $0x00eb,rail_1_bottom(%rip)   # Stop rail_1 from jumping in place (unblock rail_1)
rail_2_bottom:
    jmp footer

footer:
    ret

.global gadget_end
gadget_end:
