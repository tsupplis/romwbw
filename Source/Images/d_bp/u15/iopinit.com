�Z3ENV  �s�1�* ͚"	͖�D��
Initialize IOP Buffer, Ver 1.0, 31 Aug 92
 :] �/��*	|�� N#F#~�(yx�(u!�>^#V�	�r+s###= �* .:���N�YP!�? ���! 	�* .�w 	�w��
 ..IOP Buffer Initialized with Dummy..
 �,��
--- No IOP Buffer defined in Environment --- �,��
--- No Z-System Environment Defined --- �,��
*** IOP Already Installed ! *** �,N�q�#���= �= �= �= � � � � � � � �= �= �= �= �= Z3IOPDUMMY   ����
 �1�� - Initializes an IOP Buffer defined in the Z3 Environment
 with a Dummy IOP and patches in the BIOS Jump Table addresses.

NOTE: This routine MUST be run before any transient programs which
 cause the Warm Boot Jump at location 0 to be changed!

  Syntax:

	 �1��       <-- Initialize the IOP Buffer
	 �1�� //    <-- Display this message
 �{��:
��c��IOPINIT �![~�����|(# ������        ���D(~�� (�8#�����$ Ç�" *�|�(~#fo���"��|�� >Z�� ����(* >�O>��G>Z��  �������� ��|�� ���������! ~��#~��3ENV������� ~#� ����	(�8�(��
(	�(� ����y/�<G> �8������O>�C������K����o��* o��                                           