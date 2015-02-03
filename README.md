# cider-matlab
Code for computing the CIDEr (Consensus-based Image Description Evaluation) metric.

********************************************************************************************
********************************************************************************************
			README - CIDEr (Consensus-based Image Description Evaluation) v 0.1
								Tested on MATLAB R2013b
********************************************************************************************

Short Instructions to run the metric
-----------------------------

1. Customize parameters in parameters.m
2. Run the metric using evaluate_captions.m 
3. Results can be found in data/{$output_file}

Input
********************************************************************************************
Terminology:

*References* 
"Ground Truth" sentences provided by humans (e.g. from PASCAL-50S or MSCOCO)

*Candidates* 
Sentence whose quality is to be evaluated. E.g. "machine generated captions" or "human sentences"
whose quality is to be determined

--------------------
Main Parameters
--------------------
1. path_to_refs: Path to ".mat" file containing the reference tokens. 
				Should contain an array of struct "refs" in the following format:

				a) refs(i).image contains the name of the image as a string
				b) refs(i).sent contains a cell array of strings {1xnumber_of_reference_sentences}
					which stores all the references for the image

2. path_to_cands: Path to a ".mat" file containing the candidate sentences to be evaluated.
				Should contain an array of struct "cands" in the following format:

				a) cands(i).image contains the name of the image for which sentence is generated
				b) cands(i).sent contains a cell array of strings {1xnumber_of_candidate_sentences}
					number_of_candidate_sentences is typically ** one **

3. output_file: Name of the output file where CIDEr scores need to be stored

--------IMPORTANT-------

NOTE: Delete cache/refs folder after backing up the data whenever a new (previously unprocessed) reference dataset
 		is to be processed.
NOTE: Delete cache/cands folder after backing up the data whenever evaluating for a new set of candidates. DO NOT
		delete cache/refs if the reference dataset remains unchanged. This will cost a significant runtime overhead.

cache/refs and cache/cands contain the results of all the preprocessing needed to compute the score

--------------------
Other Parameters
--------------------

Standard Parameters:

1. ngrams: CIDEr is a mean of CIDEr ngram scores from 1 to 4. Set "ngrams = [1:4]" for default
			CIDEr.
2. stemming: CIDEr uses stemming as a preprocessing step. Set "stemming = 1" for default 
			CIDEr. 

Runtime Parameter:

If the MATLAB environment has access to parallel computing resources, set "cores = num_cores_available"
If you don't understand what parpool/matlabpool is, you should probably set "cores = 1" as default

--------------------
Output
--------------------
********************************************************************************************

1. scr: Cell array of size 1x5 containing CIDEr scores {CIDEr-1, CIDEr-2, CIDEr-3, CIDEr-4, CIDEr}.
	Each cell contains a matrix of dimension (number of references, 1)


--------------------
Data
--------------------

1. PASCAL-50S dataset, as well as the pascal reference sentences used in the paper can be found in "data" folder.
2. cache_pascal accessible from the project page contains the preprocessed files for references and candidates from the paper. Rename the cache_pascal as "cache" in the top level of the project to use the files for evaluation.

Paralellization
********************************************************************************************
Setting cores > 1 is likely to help when the reference dataset contains a large number of sentences 
per Image (>15). If that is not the case, using matlabpool could slow performance. Use your discretion.

Run-Time Estimates
********************************************************************************************
Reference Preprocessing time for PASCAL 50-S should be around 4 hours with parallelization (12 cores)
Reference Preprocessing time for PASCAL 50-S should be around 12 hours without parallelization.

Candidate Evaluation for PASCAL-50S (including preprocessing) should take around 1.5 hours. 
Candidate Evaluation for PASCAL-50S (preprocessing excluded) should take around 20 minutes.


