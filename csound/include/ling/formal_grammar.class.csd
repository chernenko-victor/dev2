class FormalGrammar
{
	public FormalGrammar(array<int>&);
	
	bool bIsNonfinite = false;

	private passOne()
	{
		foreach(aFG as iFormalGrammarK => aFormalGrammarV)
		{
			iterator<int>::i = lFinal.findArray(aFormalGrammarV[0]);
			if(i)
			{
				int iReplaceIndx = GetReplaceIndx(aFormalGrammarV.size()); 
				if(!bIsNonfinite)
				{
					bIsNonfinite = testNonfinite(aFormalGrammarV[iReplaceIndx]);
				}
				lFinal.replaceArray(aFormalGrammarV[iReplaceIndx], i, aFormalGrammarV[0].size());
			}	
		}
	}
	
	private GetReplaceIndx(int iSize)
	{
		// from 1 to size-1
	}

	private testNonfinite(array<T> &aFormalGrammarReplace)
	{
		//...
	}

	public generate()
	{
		while (true)
		{
			passOne();
			if(!bIsNonfinite)
			{
				break;
			}
		}
	}
}