#import <Foundation/Foundation.h>

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	int i, j, l;
	int num_items = 0;
	float mean = 0.0;
	float std_dev = 0.0;
	NSMutableString *allFiles = [NSMutableString stringWithCapacity:0];

	for( i=1; i<argc; ++i )
	{
		NSString *fileread = [NSString stringWithContentsOfFile:[NSString stringWithCString:argv[i]]];
		NSLog(@"Reading: %@", [NSString stringWithCString:argv[i]]);
		NSArray *rows = [fileread componentsSeparatedByString:@"\r"];
		//NSLog(@"Rows: %i", [rows count]);
		
		for( j=0; j<[rows count]-1; ++j )	//for each row, except the last one
		{
			NSArray *cols = [[rows objectAtIndex:j] componentsSeparatedByString:@"\t"];
			//NSLog(@"Cols: %i", [cols count]);
			for( l=0; l<[cols count]; ++l )
			{
				mean += [[cols objectAtIndex:l] floatValue];
				num_items++;
			}
		}
		[allFiles appendString:fileread];
	}
	NSLog(@"Sum: %@", [NSNumber numberWithFloat:mean]);
	mean = mean / num_items;
	NSLog(@"Mean: %@", [NSNumber numberWithFloat:mean]);
	
	//standard deviation calculations
	for( i=1; i<argc; ++i )
	{
		NSString *fileread = [NSString stringWithContentsOfFile:[NSString stringWithCString:argv[i]]];
		//NSLog(@"Reading: %@", [NSString stringWithCString:argv[i]]);
		NSArray *rows = [fileread componentsSeparatedByString:@"\r"];
		//NSLog(@"Rows: %i", [rows count]);
		
		for( j=0; j<[rows count]-1; ++j )	//for each row
		{
			NSArray *cols = [[rows objectAtIndex:j] componentsSeparatedByString:@"\t"];
			//NSLog(@"Cols: %i", [cols count]);
			for( l=0; l<[cols count]; ++l )
			{
				float tempstd = 0;
				tempstd = [[cols objectAtIndex:l] floatValue] - mean;
				tempstd = tempstd * tempstd;
				std_dev += tempstd;
			}
		}
	}
	
	std_dev = std_dev / (num_items); //n-1?
	std_dev = sqrt(std_dev);

	NSLog(@"std_dev: %@", [NSNumber numberWithFloat:std_dev]);
	NSLog(@"# Items: %@", [NSNumber numberWithFloat:num_items]);
	
	//do transformation for it:
	
	NSMutableArray *outputArr = [NSMutableArray arrayWithCapacity:0]; 
	for( i=1; i<argc; ++i )
	{
		NSString *fileread = [NSString stringWithContentsOfFile:[NSString stringWithCString:argv[i]]];
		//NSLog(@"Reading: %@", [NSString stringWithCString:argv[i]]);
		NSArray *rows = [fileread componentsSeparatedByString:@"\r"];
		
		//NSLog(@"Rows: %i", [rows count]);
		
		for( j=0; j<[rows count]-1; ++j )	//for each row
		{
			NSArray *cols = [[rows objectAtIndex:j] componentsSeparatedByString:@"\t"];
			//NSLog(@"Cols: %i", [cols count]);
			for( l=0; l<[cols count]; ++l )
			{
				float temp = 0;
				temp = [[cols objectAtIndex:l] floatValue] - mean;
				temp = temp / std_dev;
				[outputArr addObject:[NSNumber numberWithFloat:temp]];
			}
			
		}
	}
	
	float tempm=0;
	float temps=0;
	int numtemp;
	//calculate mean and std on transformed data
	for( i=0; i<[outputArr count]; ++i )
	{
		tempm += [[outputArr objectAtIndex:i] floatValue];
		numtemp++;
	}
	
	tempm = tempm/numtemp;
	
	NSLog(@"Calc Mean: %@", [NSNumber numberWithFloat:tempm]);
	
	for( i=0; i<[outputArr count]; ++i )
	{
		float temp2 = [[outputArr objectAtIndex:i] floatValue] - tempm;
		temp2 = temp2*temp2;
		temps += temp2;
	}
	temps = temps / numtemp;
	temps = sqrt(temps);
	
	NSLog(@"Calc STD: %@", [NSNumber numberWithFloat:temps]);
	
	//[allFiles writeToFile:@"/Users/pete/Desktop/testing/test.txt" atomically:YES];
    [pool release];
    return 0;
}
