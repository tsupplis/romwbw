�7	���� ����������_� �����>.������~� (_�� �#��������Yz�{�����x�>y�>��W�h_z�hW��Ɛ'�@'��& o�z������͆�����0��ͣ�ͣ��ͣ�ͣ �>/<	8��B�� �ɷ�> ��>�����!��'��
 ��~��#����'#��
Copy a full RomWBW hard disk slice to another slice.

Syntax:
  copysl <destunit>[.<slice>]=<srcunit>[.<slice>] [/options]
Options:
  /u - Unattented, doesnt ask for user confirmation
  /f - Full copy of slice, ignoring directory allocations
Notes:
  - drive identification is by RomWBW disk unit number
  - if slice is omitted a default of 0 is used
  - for full information please see copysl.doc

 
Invalid Arguments
       !� �A���� &�S��A�= #�A(�� �S��A�/ ���!��'!��'>����A�t�;�S�;W�_�A~���.(�:(�#�A�t�;�S�;_���#�A��J�U(�F(	�>�2��>�2���>���~��� �#��a��{���� ~�08�:0y�؁��O~�0��O#�y���08�:0����������(�
(�ɷ�  ��������X*�:�W������������X*�:�W���������hy2���"p���T]6  ���w O��l�s{�¡ A�q�p  !  |�C��~ O͖�d*z}�U ^|�� Y> 2r!>~ �.(-�   �::r� �����*p 	� ��>2r�����[p>
 �� @�q�p:r�  �~ O��l�u�t�s�r	���w
�N�F!    �(	0=���	0��N�F�B��N�F	�B��8����N�F	��N�F�J��u�t�s�r��*��[� :��
   	���� Disk Unit  �~ �q��, Slice  �~
�q��, Type =  �~�
(��hd512
 ���hd1k
 �>��>��>��   MBR_START                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                MBR_END���� ��C� :�O͖�> �� ! �~�0(�[(	�S(	 � ^#V#�**	�R0�S*	� ����(�"82.	  x� ���  	0���! �~�
(" 	**	}��o����##:��  	",	�Debug123      Debug456!��'͜��
��:��!����:�ͣ���
Source �:��!����:�ͣ���Target ��!��!��~͇��~͇��~����~ ��  �~
��
 ��~
�  �~� !��':�� w!6�'��̓��
:��(̓��
:.	� (!L�'L� 	��
Found  *(	�z�� directory entries, with  **	�z�� (4k) extents. �!���:�� !��'��Y(�y(��
��!��'́"� ��C��D��
�p��
͜�K,	x�(�C,	���
Copied  *��z�� kBytes in  ́�[���R�z�� seconds.
 !��'���  �!#�'�>!=!L!�!�
!�! �'�  �
Disk I/O Error (Code 0x ) Aborting!!
 
Source and Target disk slices must be different
 
Hard disc(s) must have matching layout (hd1k/hd512).
 
A specified disk device does not exist.
 
Only hard disc devices are supported.
 
Slice numbers must be valid and fit on the disk.
 *��[� :�O͖�> ��*�  	"�0	�[��S���*��[� :�OͰ�> ��*�  	"�0	�[��S���*� "��|�� ���    CopySlice v0.1 (RomWBW) Sept 2024 - M.Pruden
 
Warning: Copying to Slice 0 of hd512 media, will override partition table. 
 
Parsing directory.   -> Directory Not Found!
Will perform a full copy of the Slice. 
Continue (Y,N) ?  
Copying data blocks. 
 
Finished.
 SOURCE                  TARGET                  FINISH 