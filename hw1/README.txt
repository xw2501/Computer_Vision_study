what I did in this programming assignment:

	walkthrough1:
		created a .mat file named 'matrix_data.mat' for the load function.

	walkthrough2:
		as most parts of the function is are already given, I simply filled the blanks as suggested in the note.
	
	walkthrough3:
		same as walkthrough2, I filled the blanks and made some modifications so that the function can run without errors.
		eg: the origin line 60 and 61 are

			iresized_mask = [zeros(mask_height, width_diff/2),...
    iresized_mask, zeros(mask_height, width_diff/2)];

		I changed it into

			iresized_mask = [zeros(mask_height, floor(width_diff/2)),...
    iresized_mask, zeros(mask_height, ceil(width_diff/2))];

		so that the script can run when width_diff is an odd number.
		I also found variable 'mask_width' is given but has no use, because it is defined to early, by the time it is used, the
	actual value has changed. But I didn't remove it or override it.
		